//
//  LanguageSettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var languageNameOriginalLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
}

class LanguageSettingsTVC: UITableViewController {
    
    @IBOutlet weak var languageNavBarTitle: UINavigationItem!
    
    var languageNameEnglish = [String]()
    var languageNameOriginal = [String]()
    
    var selectedLanguage = Int()
    var selectedCellColor = UIView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    let languages = Language.languageFromBundle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageNameEnglish = ["English","Italian","Spanish","French","German"]
        languageNameOriginal = ["English","Italiano","Español","Français","Deutsch"]
        
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageNameEnglish.count
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        User.language_index = indexPath.row
        User.language = languages[indexPath.row]
        UserDefaults.standard.set(indexPath.row, forKey: "LANGUAGE_INDEX")
        navigationItem.title = User.language.language
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguageCell
        cell.languageNameLabel.text = languageNameEnglish[indexPath.row]
        cell.languageNameOriginalLabel.text = languageNameOriginal[indexPath.row]
        cell.checkView.image = nil
        
        if User.language_index == indexPath.row {
            cell.checkView.image = UIImage(named: "checkIcon")
        }
        
        cell.backgroundColor = currentTheme.backgroundColor
        cell.languageNameLabel.textColor = currentTheme.textColor
        cell.languageNameOriginalLabel.textColor = currentTheme.textColor
        cell.selectedBackgroundView = selectedCellColor
        
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.language
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
    }
}



