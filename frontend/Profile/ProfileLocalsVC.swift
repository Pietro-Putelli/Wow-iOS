//
//  ProfileLocalsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileLocalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var selectedCellColor = UIView()

    var images = [UIImage]()
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var selectedOwner: Friend!
    var selectedLocal: Local!
    var locals = [Local]()
    
    var localAlertView = EmptyAlertView()

    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        self.presentLoadView()
        
        localAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    func handleAlertView() {
        if locals.isEmpty {
            localAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "local"), label_1_text: User.language.no_locals_1, label_2_text: "", label_3_text: "")
        } else if localAlertView.isDescendant(of: view) {
            localAlertView.removeFromSuperview()
        }
    }
    
    func presentLoadView() {
        if !backgroundLoadView.isDescendant(of: view) {
            loadingView = LoadingView.homeLoadingView(for: view)
            backgroundLoadView = loadingView.backgroundView
            activityIndicator = loadingView.activityIndicator
            view.addSubview(backgroundLoadView)
            view.addSubview(activityIndicator)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeLoadView() {
        if backgroundLoadView.isDescendant(of: view) {
            backgroundLoadView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedLocal = locals[indexPath.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]

        view.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        navigationItem.title = User.language.local_list
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        
        Database.getLocalsByOwner(owner: selectedOwner.email) { (json) in
            DispatchQueue.main.async {
                self.locals = JSON.parseArrayLocal(json: json)
                self.tableView.reloadData()
                self.handleAlertView()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
    }
}

extension ProfileLocalsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        selectedLocal = locals[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "myLocalCell", for: indexPath) as! MyLocalsCell
        cell.selectedBackgroundView = selectedCellColor
        cell.backgroundColor = currentTheme.backgroundColor
        cell.titleLabel.textColor = currentTheme.textColor
        cell.titleLabel.text = selectedLocal.title
        cell.placeLabel.textColor = currentTheme.textColor
        cell.placeLabel.text = selectedLocal.city

        cell.ratingView.emptyImage = #imageLiteral(resourceName: "emptyStar")
        cell.ratingView.fullImage = #imageLiteral(resourceName: "fullyStar")
        cell.ratingView.tintColor = currentTheme.separatorColor
        cell.ratingView.backgroundColor = UIColor.clear
        cell.ratingView.contentMode = .scaleAspectFit
        cell.ratingView.rating = selectedLocal.rating

        cell.nReviewLabel.textColor = currentTheme.textColor

        cell.coverImageView.layer.cornerRadius = cell.coverImageView.frame.size.width / 16
        cell.coverImageView.layer.masksToBounds = true

        let downloadURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")
        Database.downloadImage(withURL: downloadURL!) { (image) in
            DispatchQueue.main.async {
                if let image = image {
                    self.images.append(image)
                } else {
                    self.images.append(UIImage())
                }
                cell.coverImageView.image = image
                
                if self.images.count < self.locals.count {
                    self.presentLoadView()
                } else {
                    self.removeLoadView()
                }
            }
        }
        return cell
    }
}
