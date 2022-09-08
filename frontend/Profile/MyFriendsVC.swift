//
//  MyFriendsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 07/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class MyFriendsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    var textFieldInsideSearchBar: UITextField?
    var expandableView = ExpandableView()
    var leftConstraint: NSLayoutConstraint!
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    var friendAlertView = EmptyAlertView()
    
    var searchTableView = SearchTVC()
    
    var isSearching = Bool()
    var selectedCellBackgroundColor = UIView()
    var images = [UIImage]()
    var refreshControl = UIRefreshControl()
    
    var selectedFriend: Friend!
    var friends = [Friend]()
    
    var selectedFriendSearch: Friend!
    var friendsSearched = [Friend]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        expandableView = ExpandableView()
        expandableView.backgroundColor = .clear
        
        refreshControl.addTarget(self, action: #selector(reloadFriends), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        friendAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    func handleFriendAlertView() {
        if friends.isEmpty {
            friendAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "friend"), label_1_text: User.language.no_friends_1, label_2_text: User.language.no_friends_2, label_3_text: User.language.no_friends_3)
        } else if friendAlertView.isDescendant(of: view) {
            friendAlertView.removeFromSuperview()
        }
    }
    
    @objc func reloadFriends() {
        Database.getUserFriends(email: User.email) { (json) in
            DispatchQueue.main.async {
                self.friends = JSON.parseArrayFriend(json: json)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.handleFriendAlertView()
            }
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
        if let destination = segue.destination as? MyProfileTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedFriend = friends[indexPath.row]
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationController?.navigationBar.tintColor = currentTheme.barColor
        navigationItem.title = User.language.my_friends
        selectedCellBackgroundColor.backgroundColor = currentTheme.selectedColor
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        self.reloadFriends()
        
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.returnKeyType = .done
        searchBar.placeholder = User.language.search_friends_placeholder
        navigationItem.titleView = searchBar
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = currentTheme.textColor
        textFieldInsideSearchBar?.font = UIFont(name: "Accuratist", size: 16.0)
        textFieldInsideSearchBar?.backgroundColor = currentTheme.barColor
        textFieldInsideSearchBar?.keyboardAppearance = currentTheme.keyboardLook
        definesPresentationContext = true
    }
}

extension MyFriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        selectedFriend = friends[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCellID", for: indexPath) as! FriendCell
        cell.selectionStyle = .default
        cell.selectedBackgroundView = selectedCellBackgroundColor
        cell.backgroundColor = currentTheme.backgroundColor
        cell.profilePicture.layer.borderWidth = 0
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2
        cell.titleLabel.textColor = currentTheme.textColor
        cell.titleLabel.text = selectedFriend.username
        
        let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedFriend.email)/profilePicture.jpg")
        
        Database.getImage(withURL: imageURL!) { (image) in
            DispatchQueue.main.async {
                
                if let image = image {
                    cell.profilePicture.image = image
                    self.images.append(image)
                } else {
                    cell.profilePicture.image = #imageLiteral(resourceName: "profilePicturePlaceholder")
                    self.images.append(#imageLiteral(resourceName: "profilePicturePlaceholder"))
                }
                
                if self.images.count < self.friends.count {
                    self.presentLoadView()
                } else {
                    self.removeLoadView()
                }
            }
        }
        return cell
    }
}

extension MyFriendsVC: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || (searchBar.text?.isEmpty)! {
            isSearching = false
            view.endEditing(true)
            self.reloadFriends()
            tableView.reloadData()
            
            if !friendAlertView.isDescendant(of: view) && friends.isEmpty {
                view.addSubview(friendAlertView)
            }
            
        } else {
            self.friends = []
            isSearching = true
            
            if friendAlertView.isDescendant(of: view) {
                friendAlertView.removeFromSuperview()
            }
            
            Database.getFriends(for: searchText, user_email: User.email) { (json) in
                DispatchQueue.main.async {
                    self.friends = JSON.parseArrayFriend(json: json)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}


