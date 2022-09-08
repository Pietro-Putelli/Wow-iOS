//
//  SettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    @IBOutlet weak var settingsNavBarTitle: UINavigationItem!
    
    var bgColorView = UIView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.usernameLabel.textColor = currentTheme.textColor
            cell.usernameLabel.text = User.name
            cell.profilePicture.image = User.profile_image
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "separatorCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = tableView.backgroundColor
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.notificationsTitleLabel.textColor = currentTheme.textColor
            cell.notificationsTitleLabel.text = User.language.notifications
            return cell
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "appearanceCell", for: indexPath) as! AppearanceSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.appearanceTitleLabel.textColor = currentTheme.textColor
            cell.appearanceTitleLabel.text = User.language.appearance
            return cell
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguageSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.languageTitleLabel.textColor = currentTheme.textColor
            cell.languageTitleLabel.text = User.language.language
            cell.currentLanguageLabel.text = User.language.id
            return cell
        case 5:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "unitsCell", for: indexPath) as! UnitsSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.unitsTitleLabel.textColor = currentTheme.textColor
            cell.unitsTitleLabel.text = User.language.measure_unit
            return cell
            
        case 6:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "manualCell", for: indexPath) as! ManualSettingsCell
            cell.selectedBackgroundView = bgColorView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.manulTitleLabel.textColor = currentTheme.textColor
            cell.manulTitleLabel.text = User.language.how_to
            return cell
            
        case 7:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.web_site.setImage(#imageLiteral(resourceName: "web_site").withRenderingMode(.alwaysTemplate), for: .normal)
            cell.web_site.tintColor = currentTheme.textColor
            
            cell.instagram.setImage(#imageLiteral(resourceName: "instagram").withRenderingMode(.alwaysTemplate), for: .normal)
            cell.instagram.tintColor = currentTheme.textColor
            
            cell.email.setImage(#imageLiteral(resourceName: "contact_us").withRenderingMode(.alwaysTemplate), for: .normal)
            cell.email.tintColor = currentTheme.textColor
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func openInstagram() {
        let instagramUrl = NSURL(string: "instagram://user?username=finix_wow")! as URL
        UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
    }
    
    func openMail() {
        let email = "finix@finixinc.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openWebSite() {
        let settingsUrl = NSURL(string: "https://finix147.wixsite.com/finix")! as URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func infoButtonsAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: self.openInstagram()
        case 1: self.openWebSite()
        case 2: self.openMail()
        default: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationItem.title = User.language.settings
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        tabBarController?.tabBar.barTintColor = currentTheme.barColor
        tabBarController?.tabBar.unselectedItemTintColor = currentTheme.notSelectedItemColor
        
        bgColorView.backgroundColor = currentTheme.selectedColor
    }
}
