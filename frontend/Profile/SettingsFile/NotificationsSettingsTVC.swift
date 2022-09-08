//
//  NotificationsSettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class LocalNotificationsTitleCell: UITableViewCell {
    @IBOutlet weak var localNotificationLabel: UILabel!
}

class EventNotificationsTitleCell: UITableViewCell {
    @IBOutlet weak var eventNotificationLabel: UILabel!
}

class FriendsNotificationsTitleCell: UITableViewCell {
    @IBOutlet weak var friendNotificationLabel: UILabel!
}

class NotifyOpenNewLocalsCell: UITableViewCell {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var switchNotify: UISwitch!
}

class NotifySetUpNewEventsCell: UITableViewCell {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var switchNotify: UISwitch!
}

class NotifyFriendsCell: UITableViewCell {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var switchNotify: UISwitch!
}

class NotifyFollowCell: UITableViewCell {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var switchNotify: UISwitch!
}

class NotifiyAnswerTitleCell: UITableViewCell {
    @IBOutlet weak var answerNotificationTitleLabel: UILabel!
}

class NotifyAnswerCell: UITableViewCell {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var switchNotify: UISwitch!
}

class NotificationsSettingsTVC: UITableViewController {
    
    @IBOutlet weak var notificationsNavBarTitle: UINavigationItem!

    var notification_settings = [Bool]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventNotificationsTitleCell", for: indexPath) as! EventNotificationsTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.eventNotificationLabel.textColor = currentTheme.textColor
            cell.eventNotificationLabel.text = User.language.events_notifications
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "notify2", for: indexPath) as! NotifySetUpNewEventsCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.switchNotify.onTintColor = currentTheme.separatorColor
            cell.switchNotify.backgroundColor = currentTheme.backgroundColor
            cell.switchNotify.tintColor = currentTheme.separatorColor
            cell.instructionLabel.textColor = currentTheme.textColor
            cell.instructionLabel.text = User.language.notification_2
            cell.switchNotify.tag = 0
            
            if !notification_settings.isEmpty {
                cell.switchNotify.isOn = notification_settings.first!
            }
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsNotificationsCell", for: indexPath) as! FriendsNotificationsTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.friendNotificationLabel.textColor = currentTheme.textColor
            cell.friendNotificationLabel.text = User.language.friends_notifications
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "notify3", for: indexPath) as! NotifyFriendsCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.instructionLabel.textColor = currentTheme.textColor
            cell.switchNotify.onTintColor = currentTheme.separatorColor
            cell.switchNotify.backgroundColor = currentTheme.backgroundColor
            cell.switchNotify.tintColor = currentTheme.separatorColor
            cell.instructionLabel.text = User.language.notification_3
            cell.switchNotify.tag = 1
            
            if !notification_settings.isEmpty {
                cell.switchNotify.isOn = notification_settings[1]
            }
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notify4", for: indexPath) as! NotifyFollowCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.instructionLabel.textColor = currentTheme.textColor
            cell.switchNotify.onTintColor = currentTheme.separatorColor
            cell.switchNotify.backgroundColor = currentTheme.backgroundColor
            cell.switchNotify.tintColor = currentTheme.separatorColor
            cell.instructionLabel.text = User.language.notification_4
            cell.switchNotify.tag = 2
            
            if !notification_settings.isEmpty {
                cell.switchNotify.isOn = notification_settings[2]
            }
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerNotificationsCell", for: indexPath) as! NotifiyAnswerTitleCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.answerNotificationTitleLabel.textColor = currentTheme.textColor
            cell.answerNotificationTitleLabel.text = User.language.friends_notifications
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notify5", for: indexPath) as! NotifyAnswerCell
            cell.backgroundColor = currentTheme.backgroundColor
            cell.instructionLabel.textColor = currentTheme.textColor
            cell.switchNotify.onTintColor = currentTheme.separatorColor
            cell.switchNotify.backgroundColor = currentTheme.backgroundColor
            cell.switchNotify.tintColor = currentTheme.separatorColor
            cell.instructionLabel.text = User.language.notification_4
            cell.switchNotify.tag = 3
            
            if !notification_settings.isEmpty {
                cell.switchNotify.isOn = notification_settings.last!
            }
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        print(sender.tag)
        if sender.isOn {
            notification_settings[sender.tag] = true
        } else {
            notification_settings[sender.tag] = false
        }
        
        let notification_settings_int = notification_settings.map { ($0 as NSNumber).intValue }
        Database.setNotificationSettings(user_email: User.email, notification_settings: notification_settings_int)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.notifications
        
        Database.getNotificationSettings(user_email: User.email) { (array) in
            DispatchQueue.main.async {
                self.notification_settings = array
                print(array)
                self.tableView.reloadData()
            }
        }
    }
}

/*
 
 case 0:
 
 let cell = tableView.dequeueReusableCell(withIdentifier: "localNotificationsTitleCell", for: indexPath) as! LocalNotificationsTitleCell
 cell.backgroundColor = currentTheme.backgroundColor
 cell.localNotificationLabel.textColor = currentTheme.textColor
 cell.localNotificationLabel.text = User.language.locals_notification
 return cell
 
 case 1:
 
 let cell = tableView.dequeueReusableCell(withIdentifier: "notify1", for: indexPath) as! NotifyOpenNewLocalsCell
 cell.backgroundColor = currentTheme.backgroundColor
 cell.switchNotify.onTintColor = currentTheme.separatorColor
 cell.switchNotify.backgroundColor = currentTheme.backgroundColor
 cell.switchNotify.tintColor = currentTheme.separatorColor
 cell.instructionLabel.textColor = currentTheme.textColor
 cell.instructionLabel.text = User.language.notification_1
 cell.switchNotify.tag = 0
 
 if !notification_settings.isEmpty {
 cell.switchNotify.isOn = notification_settings.first!
 }
 
 return cell
 
 */
