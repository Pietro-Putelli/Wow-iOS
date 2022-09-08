//
//  FriendShareVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/10/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class FriendShareVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dispatchGroup = DispatchGroup()
    
    var selectedFriend: Friend!
    var selectedFriendIDs = [Int]()
    var friends = [Friend]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
     
        let barImages = [#imageLiteral(resourceName: "darkBar"),#imageLiteral(resourceName: "darBlueBar"),#imageLiteral(resourceName: "classicBar")]
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        navigationController?.navigationBar.setBackgroundImage(barImages[themeIndex], for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        if !selectedFriendIDs.isEmpty {
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    func friendsFromBundle(email: String) {
        
        var friendsArray = [Friend]()
        
        let URL = PHP.DOMAIN + PHP.USER_FRIENDS_GET
        
        let requestURL = NSURL(string: URL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email=" + email
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        dispatchGroup.enter()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                
                guard let rootObject = (try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:AnyObject]]) else { return }
                
                self.friends = []
                
                for friendObject in rootObject {
                    if let id = friendObject["id"] as? String,
                        let email = friendObject["email"] as? String,
                        let username = friendObject["username"] as? String
                    {
                        
                        let friend = Friend(id: Int(id)!, email: email, username: username, followers: "", following: "", status: "", phone: "", businessEmail: "", webSite: "")
                        friendsArray.append(friend)
                        self.friends = friendsArray
                    }
                }
                self.dispatchGroup.leave()
            } catch {
                print(" \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor
        
        self.friendsFromBundle(email: User.email)
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}

extension FriendShareVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchFriendCell {
            cell.checkIcon.isHidden = false
            let selectedID = friends[indexPath.row].id
            selectedFriendIDs.append(selectedID)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchFriendCell {
            cell.checkIcon.isHidden = true
            selectedFriendIDs = selectedFriendIDs.filter { $0 != friends[indexPath.row].id }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedFriend = friends[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchFriendCell
        cell.backgroundColor = currentTheme.backgroundColor
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.usernameLabel.textColor = currentTheme.textColor
        cell.usernameLabel.text = selectedFriend.username
        
        cell.checkIcon.isHidden = true
        
        cell.profilePicture.layer.borderWidth = 0
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2
        
        return cell
    }
}
