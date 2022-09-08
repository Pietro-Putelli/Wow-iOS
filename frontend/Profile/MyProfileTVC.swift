//
//  MyProfileTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 07/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class MyProfileTVC: UITableViewController {
    
    var selectedBackgroundColor = UIView()
    var isNotFirstLog = Bool()
    var isFollowing = Bool()
    
    var followersTapGesture: UITapGestureRecognizer!
    var followingTapgesture: UITapGestureRecognizer!
    
    var followers = Int()
    var following = Int()
    
    var profilePictureCell = ProfilePictureCell()
        
    var selectedFriend: Friend!
    var segueImage: UIImage!
    var isFollow = Bool()
    
    var menuButton: UIButton!
    var dropMenu: UIAlertController!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuButton.setImage(#imageLiteral(resourceName: "menu2").withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.tintColor = .white
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuButton.addTarget(self, action: #selector(presentDropMenu(_:)), for: .touchUpInside)
        
        dropMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dropMenu.view.tintColor = .black
        
        let cancelAction = UIAlertAction(title: User.language.cancel, style: .cancel) { (_) in
            self.dropMenu.dismiss(animated: true, completion: nil)
        }
        dropMenu.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: User.language.report, style: .default) { (_) in
            Database.sendReportEmail(id: self.selectedFriend.id, type: 5)
        }
        dropMenu.addAction(reportAction)
        
        followersTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFollowers(_:)))
        followingTapgesture = UITapGestureRecognizer(target: self, action: #selector(tapFollowing(_:)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination_local = segue.destination as? ProfileLocalsVC {
            destination_local.selectedOwner = selectedFriend
        }
        if let destination_event = segue.destination as? ProfileEventsVC {
            destination_event.selectedOwner = selectedFriend
        }
        if let destination = segue.destination as? FriendsVC {
            destination.isFollowing = isFollowing
            destination.selectedFriend = selectedFriend
        }
    }
    
    @objc func tapFollowers(_ sender: UITapGestureRecognizer) {
        isFollowing = false
        self.performSegue(withIdentifier: "FRIEND_SEGUE", sender: self)
    }
    
    @objc func tapFollowing(_ sender: UITapGestureRecognizer) {
        isFollowing = true
        self.performSegue(withIdentifier: "FRIEND_SEGUE", sender: self)
    }
    
    @objc func presentDropMenu(_ sender: UIButton) {
        self.present(dropMenu, animated: true, completion: nil)
    }
    
    @IBAction func followButtonAction(_ sender: UIButton) {
        sender.pulse()
        if !isFollow {
            profilePictureCell.followButtonOutlet.setTitle(User.language.unfollow.uppercased(), for: .normal)
            Database.setUserFriend(user_email: User.email, friend_id: selectedFriend.id, url: PHP.DOMAIN + PHP.USER_FRIEND_ADD)
            
            let message_content = Notifications.setForFollow(user_id: User.name)
            Database.sendFollowNotification(user_id: User.email, message_content: message_content, target: selectedFriend.id)
            
            isFollow = !isFollow
        } else {
            profilePictureCell.followButtonOutlet.setTitle(User.language.follow.uppercased(), for: .normal)
            Database.setUserFriend(user_email: User.email, friend_id: selectedFriend.id, url: PHP.DOMAIN + PHP.USER_FRIEND_REMOVE)
            isFollow = !isFollow
        }
    }
    
    func setFollow(user_email: String, friend_id: Int) {
        Database.checkUserFollowing(user_email: user_email, friend_id: friend_id) { (isFollow) in
            DispatchQueue.main.async {
                self.isFollow = isFollow
                
                if isFollow {
                    self.profilePictureCell.followButtonOutlet.setTitle(User.language.unfollow.uppercased(), for: .normal)
                } else {
                    self.profilePictureCell.followButtonOutlet.setTitle(User.language.follow.uppercased(), for: .normal)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let phone = selectedFriend.phone
        let webSite = selectedFriend.webSite
        let businessEmail = selectedFriend.businessEmail

        if phone.isEmpty && webSite.isEmpty && businessEmail.isEmpty && indexPath.row == 5 { return 0 }
        else if phone.isEmpty && indexPath.row == 6 { return 0 }
        else if webSite.isEmpty && indexPath.row == 7 { return 0 }
        else if businessEmail.isEmpty && indexPath.row == 8 { return 0 }
        else { return UITableViewAutomaticDimension }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
            if let url = URL(string: "tel://\(selectedFriend.phone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 7 {
            let settingsUrl = NSURL(string: selectedFriend.webSite)! as URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else if indexPath.row == 8 {
            if let url = URL(string: "mailto:\(selectedFriend.businessEmail)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {

        case 0:
            
            profilePictureCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ProfilePictureCell
            profilePictureCell.selectionStyle = .none
            profilePictureCell.backgroundColor = currentTheme.backgroundColor
            profilePictureCell.profileImageView.layer.borderWidth = 0
            profilePictureCell.profileImageView.layer.masksToBounds = false
            profilePictureCell.profileImageView.layer.cornerRadius = profilePictureCell.profileImageView.frame.height / 2
            profilePictureCell.profileImageView.clipsToBounds = true
            
            let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedFriend.email)/profilePicture.jpg")
            
            Database.getImage(withURL: imageURL!) { (image) in
                DispatchQueue.main.async {
                    if let image = image {
                        self.profilePictureCell.profileImageView.image = image
                    } else {
                        self.profilePictureCell.profileImageView.image = #imageLiteral(resourceName: "profilePicturePlaceholder")
                    }
                }
            }
            
            profilePictureCell.usernameLabel.textColor = currentTheme.textColor
            profilePictureCell.followersLabel.textColor = currentTheme.textColor
            profilePictureCell.numberOfFollowers.textColor = currentTheme.textColor
            profilePictureCell.followingLabel.textColor = currentTheme.textColor
            profilePictureCell.numberOfFollowing.textColor = currentTheme.textColor
            profilePictureCell.followButtonOutlet.backgroundColor = currentTheme.separatorColor
            profilePictureCell.followButtonOutlet.setTitleColor(currentTheme.backgroundColor, for: .normal)
            profilePictureCell.followButtonOutlet.layer.cornerRadius = profilePictureCell.followButtonOutlet.frame.height / 2
            profilePictureCell.followButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
            profilePictureCell.followButtonOutlet.addTarget(self, action: #selector(handleFollowersFollowing), for: .allTouchEvents)
            
            profilePictureCell.separatorView.backgroundColor = currentTheme.separatorColor
            profilePictureCell.separatorView.frame.size.height = 0.5
            
            profilePictureCell.usernameLabel.text = selectedFriend.username
            profilePictureCell.numberOfFollowers.text = String(followers)
            profilePictureCell.numberOfFollowing.text = String(following)
            
            profilePictureCell.followersLabel.text = User.language.followers
            profilePictureCell.followingLabel.text = User.language.following
            
            profilePictureCell.numberOfFollowers.isUserInteractionEnabled = true
            profilePictureCell.numberOfFollowing.isUserInteractionEnabled = true
            
            profilePictureCell.numberOfFollowers.addGestureRecognizer(followersTapGesture)
            profilePictureCell.numberOfFollowing.addGestureRecognizer(followingTapgesture)
            
            self.setFollow(user_email: User.email, friend_id: selectedFriend.id)
            
            if selectedFriend.email == User.email {
                profilePictureCell.followButtonOutlet.isEnabled = false
            }
            
            return profilePictureCell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ProfileAboutTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundSeparatorColor
            cell.aboutLabel.textColor = currentTheme.textColor
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ProfileStatusCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.statusContentLabel.textColor = currentTheme.textColor
            cell.statusContentLabel.text = selectedFriend.status
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ProfileMyEventsCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedBackgroundColor
            cell.backgroundColor = currentTheme.backgroundColor
            cell.eventsTitleLabel.textColor = currentTheme.textColor
            cell.eventsTitleLabel.text = User.language.event_list
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell41", for: indexPath) as! ProfileMyEventsCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedBackgroundColor
            cell.backgroundColor = currentTheme.backgroundColor
            cell.eventsTitleLabel.textColor = currentTheme.textColor
            cell.eventsTitleLabel.text = User.language.local_list
            return cell
            
        case 5:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! ProfileContactsTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundSeparatorColor
            cell.contactsLabel.textColor = currentTheme.textColor
            cell.contactsLabel.text = User.language.contacts
            cell.topSeparator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.33)
            cell.topSeparator.backgroundColor = currentTheme.separatorColor.withAlphaComponent(0.5)
            return cell
            
        case 6,7,8:
            
            let icons = [#imageLiteral(resourceName: "phone1"),#imageLiteral(resourceName: "webSite1"),#imageLiteral(resourceName: "email1")]
            let titles = [selectedFriend.phone,selectedFriend.webSite,selectedFriend.businessEmail]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! ProfileContactsCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedBackgroundColor
            cell.backgroundColor = currentTheme.backgroundColor
            cell.icon.image = icons[indexPath.row - 6]
            cell.contactTitleLabel.text = titles[indexPath.row - 6]
            return cell
            
        case 9:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! ProfileLastCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundSeparatorColor
            cell.bottomSeparator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.33)
            cell.bottomSeparator.backgroundColor = currentTheme.separatorColor.withAlphaComponent(0.5)
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    @objc func handleFollowersFollowing() {
        Database.getUserFollowersNumber(friend_id: selectedFriend.id) { (followers) in
            DispatchQueue.main.async {
                self.followers = followers
                self.tableView.reloadData()
            }
        }
        
        Database.getuserFollowingNumber(user_id: selectedFriend.email) { (following) in
            DispatchQueue.main.async {
                self.following = following
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        selectedBackgroundColor.backgroundColor = currentTheme.selectedColor
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        navigationController?.navigationBar.tintColor = currentTheme.barColor
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        
        navigationItem.title = selectedFriend.username
        
        self.handleFollowersFollowing()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}




