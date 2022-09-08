//
//  FriendsSearchController.swift
//  eventsProject
//
//  Created by Pietro Putelli on 05/10/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class SearchFriendCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkIcon: UIImageView!
}

class SearchTVC: UITableViewController {

    var friends = [Friend]()
    var selectedFriend: Friend!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedFriend = friends[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchFriendCell
        cell.backgroundColor = currentTheme.backgroundColor
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = currentTheme.selectedItemColor
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.usernameLabel.textColor = currentTheme.textColor
        cell.usernameLabel.text = selectedFriend.username
        
        cell.profilePicture.layer.borderWidth = 0
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2

        let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedFriend.email)/profilePicture.jpg")
        Database.getImage(withURL: imageURL!) { (image) in
            DispatchQueue.main.async {
                cell.profilePicture.image = image
            }
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor
    }
}

extension SearchTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
        guard let searchBarText = searchController.searchBar.text else { return }
        Database.getFriends(for: searchBarText, user_email: User.email) { (json) in
            DispatchQueue.main.async {
                self.friends = JSON.parseArrayFriend(json: json)
                self.tableView.reloadData()
            }
        }
    }
}
