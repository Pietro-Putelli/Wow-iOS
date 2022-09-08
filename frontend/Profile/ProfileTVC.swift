//
//  ProfileVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 13/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileNavBarTitle: UINavigationItem!
    
    var followers = Int()
    var following = Int()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    var imageView = UIImageView()
    var selectedCellBackgroundView = UIView()
    
    var isNotFirstLog = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        if (UserDefaults.standard.value(forKey: "USER_FIRST_LOG") == nil) { isNotFirstLog = false }
        else { isNotFirstLog = UserDefaults.standard.value(forKey: "USER_FIRST_LOG") as! Bool }
        
        tableView.reloadData()
        tableView.backgroundColor = .clear
        tableView.separatorColor = currentTheme.separatorColor
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        selectedCellBackgroundView.backgroundColor = currentTheme.selectedColor
        navigationItem.title = User.language.profile
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        
        Database.getUserFollowersNumber(friend_id: User.id) { (followers) in
            DispatchQueue.main.async {
                self.followers = followers
                self.tableView.reloadData()
            }
        }
        
        Database.getuserFollowingNumber(user_id: User.email) { (following) in
            DispatchQueue.main.async {
                self.following = following
                self.tableView.reloadData()
            }
        }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileGeneralsCell", for: indexPath) as! ProfileGeneralsCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.userName.textColor = currentTheme.textColor
            cell.userName.text = User.name
            cell.statusContentLabel.textColor = currentTheme.textColor
            cell.statusContentLabel.text = User.status
            cell.separatorView.backgroundColor = currentTheme.separatorColor
            cell.numFollowersLabel.textColor = currentTheme.textColor
            cell.followersTitleLabel.textColor = currentTheme.textColor
            cell.numFollowingLabel.textColor = currentTheme.textColor
            cell.followingLabel.textColor = currentTheme.textColor
            
            cell.profilePicture.layer.borderWidth = 0
            cell.profilePicture.layer.masksToBounds = false
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height / 2
            cell.profilePicture.clipsToBounds = true
            
            cell.numFollowersLabel.text = String(followers)
            cell.numFollowingLabel.text = String(following)
            
            if !isNotFirstLog {
                
                isNotFirstLog = true
                UserDefaults.standard.set(isNotFirstLog, forKey: "USER_FIRST_LOG")
                imageView.setImageFromURl(stringImageUrl: "https://finixinc.com/usersAccountData/\(User.email)/profilePicture.jpg")
                
                if imageView.image != nil {
                    let imageData:NSData = UIImagePNGRepresentation(imageView.image!)! as NSData
                    UserDefaults.standard.set(imageData, forKey: "USER_PP")
                } else { imageView.image = #imageLiteral(resourceName: "profilePicturePlaceholder")}
            } else {
                let data = UserDefaults.standard.value(forKey: "USER_PP") as! NSData
                imageView.image = UIImage(data: data as Data)
            }
            
            cell.profilePicture.image = imageView.image
            cell.statusContentLabel.text = User.status
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myLocalsCell", for: indexPath) as! MyLocalsTitleCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellBackgroundView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myLocalsLabel.textColor = currentTheme.textColor
            cell.myLocalsLabel.text = User.language.my_locals
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath) as! MyEventTitleCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellBackgroundView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myEventsTitleLabel.textColor = currentTheme.textColor
            cell.myEventsTitleLabel.text = User.language.my_events
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! MyFriendTitleCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellBackgroundView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myFriendTitleLabel.textColor = currentTheme.textColor
            cell.myFriendTitleLabel.text = User.language.my_friends
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFavTitleCell", for: indexPath) as! MyFavouritesCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellBackgroundView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myFavTitleLabel.textColor = currentTheme.textColor
            cell.myFavTitleLabel.text = User.language.my_fav
            return cell
            
        default: return UITableViewCell()
        }
    }
}
