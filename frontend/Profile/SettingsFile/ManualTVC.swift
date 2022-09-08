//
//  ManualTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 08/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ManualTVC: UITableViewController {

    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Class2
            cell.backgroundColor = currentTheme.backgroundColor
            cell.aboutTitleLabel.textColor = currentTheme.textColor
            cell.aboutTitleLabel.text = User.language.about_wow
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! Class3
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contentLabel1.textColor = currentTheme.textColor
            cell.contentLabel2.textColor = currentTheme.textColor
            cell.contentLabel1.text = User.language.text_01
            cell.contentLabel2.text = User.language.text_02
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! Class4
            cell.backgroundColor = currentTheme.backgroundColor
            cell.createLocalLabel.textColor = currentTheme.textColor
            cell.createLocalLabel.text = User.language.create_local
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! Class5
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contentLabel1.textColor = currentTheme.textColor
            cell.contentLabel2.textColor = currentTheme.textColor
            cell.contentLabel1.text = User.language.text_03
            cell.contentLabel2.text = User.language.text_04
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! Class6
            cell.backgroundColor = currentTheme.backgroundColor
            cell.creteEventLabel.textColor = currentTheme.textColor
            cell.creteEventLabel.text = User.language.event_set
            return cell
            
        case 5:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! Class7
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contentLabel1.textColor = currentTheme.textColor
            cell.contentLabel4.textColor = currentTheme.textColor
            cell.contentLabel1.text = User.language.text_05
            cell.contentLabel4.text = User.language.text_06
            return cell
            
        case 6:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! Class8
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contactLabel.textColor = currentTheme.textColor
            cell.contactLabel.text = User.language.contact_us
            return cell
            
        case 7:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! Class9
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contentLabel1.textColor = currentTheme.textColor
            cell.emailButtonOutlet.setTitleColor(currentTheme.separatorColor, for: .normal)
            cell.contentLabel2.textColor = currentTheme.textColor
            cell.contentLabel1.text = User.language.text_07
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        tableView.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.how_to
    }
}
