//
//  AppearanceSettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ThemesTypeCell: UITableViewCell {
    
    @IBOutlet weak var themesTypeTitleLabel: UILabel!
}

class ThemeCell: UITableViewCell {
    
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
}

class AppearanceSettingsTVC: UITableViewController {

    @IBOutlet weak var appearanceNavBarTitle: UINavigationItem!
    
    var selectedTheme = Int()
    var themeName = [String]()
    var themeType = Int()

    let selectedCellColor = UIView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        self.reloadColors()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row != 0 {
            
            selectedTheme = indexPath.row
            let themeIndex = selectedTheme - 1
            
            UserDefaults.standard.setValue(themeIndex, forKey: "THEME_TYPE")
            tableView.reloadData()
            self.reloadColors()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! ThemeCell
            cell.themeNameLabel.text = themeName[indexPath.row - 1]
            cell.checkView.image = nil
            
            if selectedTheme == (indexPath.row) {cell.checkView.image = UIImage(named: "checkIcon")}
            
            cell.backgroundColor = currentTheme.backgroundColor
            cell.selectedBackgroundView = selectedCellColor
            cell.themeNameLabel.textColor = currentTheme.textColor
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "themeTypeCell", for: indexPath) as! ThemesTypeCell
            cell.selectionStyle = .none
            cell.backgroundColor = tableView.backgroundColor
            cell.themesTypeTitleLabel.textColor = currentTheme.textColor
            cell.themesTypeTitleLabel.text = User.language.them_type
            return cell
        }
    }
    
    func reloadColors() {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        selectedTheme = themeIndex + 1
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.appearance
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        themeName = [User.language.dark,User.language.dark_blue,User.language.light]
    }
}





