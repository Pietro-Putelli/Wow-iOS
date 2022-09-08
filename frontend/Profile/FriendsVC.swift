//
//  FriendsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 29/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol FriendDataDelegate {
    func segueData(selectedFriend: Friend)
}

class FriendsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCellBackgroundColor = UIView()
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var isFollowing = Bool()
    
    var images = [UIImage]()
    
    var friendDelegate: FriendDataDelegate?
    
    var selectedFriend: Friend!
    var selectedFriendSegue: Friend!
    var friends = [Friend]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
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
    
    func presentPofileVC() {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "myProfileID") as! MyProfileTVC
        profileVC.selectedFriend = selectedFriendSegue
        profileVC.isFollowing = isFollowing
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        tableView.backgroundColor = .clear
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        selectedCellBackgroundColor.backgroundColor = currentTheme.selectedColor
        
        if isFollowing {
            Database.getUserFriends(email: selectedFriend.email) { (json) in
                DispatchQueue.main.async {
                    self.friends = JSON.parseArrayFriend(json: json)
                    self.tableView.reloadData()
                }
            }
            navigationItem.title = User.language.following
        } else {
            Database.getUserFollowers(friend_id: selectedFriend.id) { (json) in
                DispatchQueue.main.async {
                    self.friends = JSON.parseArrayFriend(json: json)
                    self.tableView.reloadData()
                }
            }
            navigationItem.title = User.language.followers
        }
    }
}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriendSegue = friends[indexPath.row]
        self.presentPofileVC()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedFriendSegue = friends[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCellID", for: indexPath) as! FriendCell
        cell.selectionStyle = .default
        cell.selectedBackgroundView = selectedCellBackgroundColor
        cell.backgroundColor = currentTheme.backgroundColor
        cell.profilePicture.layer.borderWidth = 0
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2
        cell.titleLabel.textColor = currentTheme.textColor
        cell.titleLabel.text = selectedFriendSegue.username
        
        let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedFriendSegue.email)/profilePicture.jpg")
        
        Database.getImage(withURL: imageURL!) { (image) in
            DispatchQueue.main.async {
                
                if let image = image {
                    cell.profilePicture.image = image
                    self.images.append(image)
                } else {
                    self.images.append(UIImage())
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
