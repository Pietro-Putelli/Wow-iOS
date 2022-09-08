//
//  ProfileVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 13/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

struct PROFILE_CELL {
    static let CELL_1 = "CELL_1"
    static let CELL_2 = "CELL_2"
    static let CELL_3 = "CELL_3"
    static let CELL_4 = "CELL_4"
    static let CELL_5 = "CELL_5"
}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var followers = Int()
    var following = Int()
    
    var selectedFriend: Friend!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    var imageView = UIImageView()
    var selectedCellBackgroundView = UIView()
    
    var isFollowing = Bool()
    
    var tapFollowing: UITapGestureRecognizer!
    var tapFollowers: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.tag = TabbarItemTag.profile.rawValue
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        self.setCollectionViewFlowLayout()
        
        tapFollowing = UITapGestureRecognizer(target: self, action: #selector(tapFollowing(_:)))
        tapFollowers = UITapGestureRecognizer(target: self, action: #selector(tapFollowers(_:)))
        
       selectedFriend = Friend(id: User.id, email: User.email, username: User.name, followers: "", following: "", status: "", phone: "", businessEmail: "", webSite: "")

        if let data = UserDefaults.standard.value(forKey: USER_KEYS.PROFILE_PICTURE) as? NSData {
            User.profile_image = UIImage(data: data as Data)
        } else {
            let url = URL(string: "https://finixinc.com/usersAccountData/\(User.email)/profilePicture.jpg")!
            
            Database.downloadImage(withURL: url) { (image) in
                if let image = image {
                    Image.setImage(image: image)
                    User.profile_image = image
                } else {
                    Image.setImage(image: #imageLiteral(resourceName: "profilePicturePlaceholder"))
                    User.profile_image = #imageLiteral(resourceName: "profilePicturePlaceholder")
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func tapFollowers(_ sender: UITapGestureRecognizer) {
        isFollowing = false
        self.performSegue(withIdentifier: "FOLLOW_SEGUE", sender: self)
    }
    
    @objc func tapFollowing(_ sender: UITapGestureRecognizer) {
        isFollowing = true
        self.performSegue(withIdentifier: "FOLLOW_SEGUE", sender: self)
    }
    
    func setCollectionViewFlowLayout() {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = insetX / 2
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = cellWidth
        collectionView.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FriendsVC {
            destination.isFollowing = isFollowing
            destination.selectedFriend = selectedFriend
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        collectionView.reloadData()
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        selectedCellBackgroundView.backgroundColor = currentTheme.selectedColor
        navigationItem.title = User.language.profile
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO.withSize(18), font_2: FONTS.ACCURATIST)
        
        Database.getUserFollowersNumber(friend_id: User.id) { (followers) in
            DispatchQueue.main.async {
                self.followers = followers
                self.collectionView.reloadData()
            }
        }
        
        Database.getuserFollowingNumber(user_id: User.email) { (following) in
            DispatchQueue.main.async {
                self.following = following
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO.withSize(18), font_2: FONTS.ACCURATIST)
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        var cellHeight: CGFloat!
        
        if indexPath.row != 0 {
            cellHeight = 60.0
        } else {
            cellHeight = 200.0
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_CELL.CELL_1, for: indexPath) as! ProfileGeneralsCell
            
            cell.backgroundColor = currentTheme.backgroundColor
            cell.userName.textColor = currentTheme.textColor
            cell.userName.text = User.name
            cell.statusContentLabel.textColor = currentTheme.textColor
            cell.statusContentLabel.text = User.status
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
            
            cell.followersTitleLabel.text = User.language.followers
            cell.followingLabel.text = User.language.following
            
            cell.numFollowersLabel.isUserInteractionEnabled = true
            cell.numFollowingLabel.isUserInteractionEnabled = true
            
            cell.numFollowersLabel.addGestureRecognizer(tapFollowers)
            cell.numFollowingLabel.addGestureRecognizer(tapFollowing)
            cell.statusContentLabel.text = User.status
            
            cell.profilePicture.image = User.profile_image
            
            return cell
            
        case 1:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_CELL.CELL_2, for: indexPath) as! MyLocalsTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myLocalsLabel.textColor = currentTheme.textColor
            cell.myLocalsLabel.text = User.language.my_locals
            return cell
            
        case 2:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_CELL.CELL_3, for: indexPath) as! MyEventTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myEventsTitleLabel.textColor = currentTheme.textColor
            cell.myEventsTitleLabel.text = User.language.my_events
            return cell
            
        case 3:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_CELL.CELL_4, for: indexPath) as! MyFriendTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myFriendTitleLabel.textColor = currentTheme.textColor
            cell.myFriendTitleLabel.text = User.language.my_friends
            return cell
            
        case 4:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_CELL.CELL_5, for: indexPath) as! MyFavouritesCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.myFavTitleLabel.textColor = currentTheme.textColor
            cell.myFavTitleLabel.text = User.language.my_fav
            return cell
            
        default: return UICollectionViewCell()
        }
    }
}
