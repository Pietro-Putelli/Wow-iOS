//
//  LocalInfoIconTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 01/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class LocalInfoIconCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchS: UISwitch!
}

class LocalInfoIconTVC: UITableViewController {
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var icons = [UIImage]()
    var titles = [String]()
    
    var quickInfosSelected = [Int]()
    var quickInfoCellTags = [Int]()
    
    var iconCell = LocalInfoIconCell()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        
        icons = [#imageLiteral(resourceName: "parking1"),#imageLiteral(resourceName: "wifi"),#imageLiteral(resourceName: "music2"),#imageLiteral(resourceName: "tv"),#imageLiteral(resourceName: "place1"),#imageLiteral(resourceName: "sport1"),#imageLiteral(resourceName: "games1"),#imageLiteral(resourceName: "slot"),#imageLiteral(resourceName: "kids1"),#imageLiteral(resourceName: "cocktail1"),#imageLiteral(resourceName: "food1"),#imageLiteral(resourceName: "cake2"),#imageLiteral(resourceName: "pizza1"),#imageLiteral(resourceName: "wine1"),#imageLiteral(resourceName: "dog")]
        titles = ["Parking","Free wifi","Music","TV","Outside sitting","Sport","Games","Slot","Good for kids","Cocktails","Food","Birthday","Take away food","Food and wine","Pets"]
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        iconCell = tableView.dequeueReusableCell(withIdentifier: "infoIconCellID", for: indexPath) as! LocalInfoIconCell
        iconCell.selectionStyle = .none
        iconCell.backgroundColor = currentTheme.backgroundColor
        iconCell.iconView.image = icons[indexPath.row]
        iconCell.titleLabel.text = titles[indexPath.row]
        return iconCell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(quickInfosSelected, forKey: "QUICK_INFOS")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        navBarItem.title = "Quick information"
        
        tableView.backgroundColor = currentTheme.backgroundColor
    }
}
