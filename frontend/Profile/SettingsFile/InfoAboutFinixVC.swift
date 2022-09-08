//
//  InfoAboutFinixTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 05/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class InfoAboutFinixVC: UIViewController {
    
    @IBOutlet weak var finix_titile_label: UILabel!
    @IBOutlet weak var finix_slogan_label: UILabel!
    @IBOutlet weak var pietro_putelli_label: UILabel!
    @IBOutlet weak var copyright_label: UILabel!
    
    @IBOutlet weak var web_button: UIButton!
    @IBOutlet weak var instagram_button: UIButton!
    @IBOutlet weak var email_button: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    @IBAction func openInstagram(_ sender: UIButton) {
        let instagramUrl = NSURL(string: "instagram://user?username=finixinc_official")! as URL
        UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func openMail(_ sender: UIButton) {
        let email = "finix@finixinc.com"
        if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
        }
    }
    
    @IBAction func openWebSite(_ sender: UIButton) {
        let settingsUrl = NSURL(string: "https://finix147.wixsite.com/finix")! as URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        finix_titile_label.textColor = currentTheme.textColor
        finix_slogan_label.textColor = currentTheme.textColor
        pietro_putelli_label.textColor = currentTheme.textColor
        copyright_label.textColor = currentTheme.textColor
        
        web_button.setImage(#imageLiteral(resourceName: "web_site").withRenderingMode(.alwaysTemplate), for: .normal)
        web_button.tintColor = currentTheme.textColor
        
        instagram_button.setImage(#imageLiteral(resourceName: "instagram").withRenderingMode(.alwaysTemplate), for: .normal)
        instagram_button.tintColor = currentTheme.textColor
        
        email_button.setImage(#imageLiteral(resourceName: "contact_us").withRenderingMode(.alwaysTemplate), for: .normal)
        email_button.tintColor = currentTheme.textColor
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.info_finix
    }
}
