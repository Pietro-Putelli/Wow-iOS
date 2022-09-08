//
//  MyFavourites.swift
//  eventsProject
//
//  Created by Pietro Putelli on 06/10/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FavouriteLocalCell: UITableViewCell {
    
    @IBOutlet weak var localPicuture: UIImageView!
    @IBOutlet weak var localTitleLabel: UILabel!
    @IBOutlet weak var localPlaceLabel: UILabel!
    @IBOutlet weak var timetableLabel: UILabel!
    @IBOutlet weak var localRateView: RatingView!
}

class MyFavouritesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouritesNavBarTitle: UINavigationItem!
    @IBOutlet var noFavView: UIView!
    
    var selectedCellColor = UIView()
    var favLocalsID = [Int]()
    var images = [UIImage]()
    
    var refreshControl = UIRefreshControl()

    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    var favAlertView = EmptyAlertView()
    
    var favouriteLocals = [Local]()
    var selectedLocal: Local! = nil
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        refreshControl.addTarget(self, action: #selector(reloadDBData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        favAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    @objc func reloadDBData() {
        Database.getFavouriteLocalsArray(email: User.email) { (json) in
            DispatchQueue.main.async {
                self.favouriteLocals = JSON.parseArrayLocal(json: json)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func handleFavAlertView() {
        if favouriteLocals.isEmpty {
            favAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "fullyHeart"), label_1_text: User.language.no_fav_1, label_2_text: User.language.no_fav_2, label_3_text: "")
        } else if favAlertView.isDescendant(of: view) {
            favAlertView.removeFromSuperview()
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
            destination.selectedLocal = favouriteLocals[indexPath.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor

        Database.getFavouriteLocalsArray(email: User.email) { (json) in
            DispatchQueue.main.async {
                if !json.isEmpty {
                    self.favouriteLocals = JSON.parseArrayLocal(json: json)
                    self.tableView.reloadData()
                    self.handleFavAlertView()
                } else {
                    self.handleFavAlertView()
                }
            }
        }
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.my_fav
        selectedCellColor.backgroundColor = currentTheme.selectedColor
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
    }
}

extension MyFavouritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteLocals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedLocal = favouriteLocals[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "localCell", for: indexPath) as! FavouriteLocalCell
        cell.selectedBackgroundView = selectedCellColor
        cell.backgroundColor = currentTheme.backgroundColor
        cell.localTitleLabel.textColor = currentTheme.textColor
        cell.localPlaceLabel.textColor = currentTheme.textColor
        cell.localTitleLabel.text = selectedLocal.title
        cell.localPlaceLabel.text = selectedLocal.city
        
        cell.localRateView.emptyImage = #imageLiteral(resourceName: "emptyStar")
        cell.localRateView.fullImage = #imageLiteral(resourceName: "fullyStar")
        cell.localRateView.tintColor = currentTheme.separatorColor
        cell.localRateView.backgroundColor = UIColor.clear
        cell.localRateView.contentMode = .scaleAspectFit
        cell.localRateView.rating = selectedLocal.rating
        
        cell.timetableLabel.text = Time.getTimetable(timetable: selectedLocal.timetable)
        cell.timetableLabel.textColor = currentTheme.textColor
        
        cell.localPicuture.layer.cornerRadius = cell.localPicuture.frame.size.width / 16
        cell.localPicuture.layer.masksToBounds = true
        
        let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")
        Database.getImage(withURL: imageURL!) { (image) in
            DispatchQueue.main.async {
                if let image = image {
                    cell.localPicuture.image = image
                    self.images.append(image)
                } else {
                    self.images.append(UIImage())
                }
                
                if self.images.count < self.favouriteLocals.count {
                    self.presentLoadView()
                } else {
                    self.removeLoadView()
                }
            }
        }
        return cell
    }
}
