//
//  LocalEventsList.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class LocalEventListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!

    var selectedBackgorund = UIView()
    
    var selectedLocal: Local!
    
    var selectedEvent: Event!
    var events = [Event]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventsTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedEvent = events[indexPath.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.event_list
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor
        
        selectedBackgorund.backgroundColor = currentTheme.selectedColor
        
        Database.getLocalEvents(id: selectedLocal.id!) { (json) in
            DispatchQueue.main.async {
                self.events = JSON.parseArrayEvent(json: json)
                self.tableView.reloadData()
            }
        }
        
        if let indePath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indePath, animated: true)
        }
    }
}

extension LocalEventListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedEvent = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as! MyEventCell
        cell.backgroundColor = currentTheme.backgroundColor
        cell.selectedBackgroundView = selectedBackgorund
        
        cell.titleLabel.textColor = currentTheme.textColor
        cell.setupbyLabel.textColor = currentTheme.textColor
        cell.likesLabel.textColor = currentTheme.textColor
        cell.dateLabel.textColor = currentTheme.textColor
        
        cell.titleLabel.text = selectedEvent.title
        cell.setupbyLabel.text = selectedEvent.setUpBy
        cell.likesLabel.text = String(selectedEvent.likes) + " likes"
        cell.dateLabel.text = "\(selectedEvent.fromDate) - \(selectedEvent.toDate)"
        
        cell.coverImg.layer.cornerRadius = cell.coverImg.frame.size.width / 16
        cell.coverImg.layer.masksToBounds = true
        
        let downloadURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedEvent.owner)/userEvents/\(selectedEvent.owner)\(selectedEvent.id!)/coverImg.jpg")
        
        Database.downloadImage(withURL: downloadURL!) { (image) in
            cell.coverImg.image = image
        }
        
        return cell
    }
}



