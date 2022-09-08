//
//  MyLocalsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 05/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyLocalsCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nReviewLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
}

class MyLocalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myLocalsNavBarTitle: UINavigationItem!
    @IBOutlet var deleteView: DeleteAlertView!
    
    var backgroundLogOutView = UIView()
    
    var selectedCellColor = UIView()
    var addButton = UIButton()
    
    var delegateDelete = DelegateDelete()
    
    var selectedLocal: Local!
    var locals = [Local]()
    
    var images = [UIImage]()
    
    var refreshControl = UIRefreshControl()
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    var localAlertView = EmptyAlertView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        self.presentLoadView()
        
        refreshControl.addTarget(self, action: #selector(reloadDBData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        localAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    func handleAlertView() {
        if locals.isEmpty {
            localAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "local"), label_1_text: User.language.no_locals_1, label_2_text: User.language.no_locals_2, label_3_text: User.language.top_button)
        } else if localAlertView.isDescendant(of: view) {
            localAlertView.removeFromSuperview()
        }
    }
    
    @objc func reloadDBData() {
        Database.getLocalsByOwner(owner: User.email) { (json) in
            DispatchQueue.main.async {
                self.locals = JSON.parseArrayLocal(json: json)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateLocalTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedLocal = locals[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? MyLocalsCell {
                destination.imageView.image = cell.coverImageView.image
            }
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        sender.pulse()
        Database.delete(id: delegateDelete.selectedLocal.id!, url: PHP.DOMAIN + PHP.DELETE_LOCAL)
        self.locals.remove(at: delegateDelete.indexPathSelected.row)
        tableView.deleteRows(at: [delegateDelete.indexPathSelected], with: .automatic)
        tableView.reloadData()
        deleteView.removeDeleteAlertView(view: view)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        sender.pulse()
        deleteView.removeDeleteAlertView(view: view)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.my_locals
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        Database.getLocalsByOwner(owner: User.email) { (json) in
            DispatchQueue.main.async {
                self.locals = JSON.parseArrayLocal(json: json)
                self.tableView.reloadData()
                self.handleAlertView()
            }
        }
    }
}

extension MyLocalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locals.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        delegateDelete.indexPathSelected = indexPath
        delegateDelete.selectedLocal = locals[indexPath.row]
        
        let action =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler) in
            self.deleteView.presentDelterAlertView(view: self.view)
            completionHandler(true)
        })
        action.image = #imageLiteral(resourceName: "trash1").withRenderingMode(.alwaysTemplate)
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
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




