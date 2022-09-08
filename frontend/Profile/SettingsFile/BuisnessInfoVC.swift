//
//  BuisnessInfo.swift
//  eventsProject
//
//  Created by Pietro Putelli on 18/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

extension BuisnessInfoVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength < 21
    }
}

class BuisnessInfoVC: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var webSiteTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!

    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(setData), for: .touchUpInside)
        
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    @objc func setData() {
        let phoneText = phoneTF.text!
        let webSiteText = webSiteTF.text!
        let buisnessEmailText = emailTF.text!
        
        Database.uploadBusinessInfo(user_id: User.email, email: buisnessEmailText, web_site: webSiteText, phone_number: phoneText)
        
        User.phone = phoneText
        User.web_site = webSiteText
        User.business_email = buisnessEmailText
        
        UserDefaults.standard.set(phoneText, forKey: USER_KEYS.PHONE)
        UserDefaults.standard.set(webSiteText, forKey: USER_KEYS.WEB_SITE)
        UserDefaults.standard.set(buisnessEmailText, forKey: USER_KEYS.BUSINESS_EMAIL)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.business_info
        
        phoneTF.textColor = currentTheme.textColor
        phoneTF.attributedPlaceholder = NSAttributedString(string: User.language.phone.removeParenteses(), attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        phoneTF.keyboardAppearance = currentTheme.keyboardLook
        phoneTF.borderStyle = .none
        phoneTF.backgroundColor = currentTheme.backgroundColor
        phoneTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        phoneTF.layer.masksToBounds = false
        phoneTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        phoneTF.layer.shadowOpacity = 1.0
        phoneTF.layer.shadowRadius = 0.0
        phoneTF.becomeFirstResponder()
        
        webSiteTF.textColor = currentTheme.textColor
        webSiteTF.attributedPlaceholder = NSAttributedString(string: User.language.web_site_link.removeParenteses(), attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        webSiteTF.keyboardAppearance = currentTheme.keyboardLook
        webSiteTF.borderStyle = .none
        webSiteTF.backgroundColor = currentTheme.backgroundColor
        webSiteTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        webSiteTF.layer.masksToBounds = false
        webSiteTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        webSiteTF.layer.shadowOpacity = 1.0
        webSiteTF.layer.shadowRadius = 0.0
        
        emailTF.textColor = currentTheme.textColor
        emailTF.attributedPlaceholder = NSAttributedString(string: "Business email", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        emailTF.keyboardAppearance = currentTheme.keyboardLook
        emailTF.borderStyle = .none
        emailTF.backgroundColor = currentTheme.backgroundColor
        emailTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        emailTF.layer.masksToBounds = false
        emailTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        emailTF.layer.shadowOpacity = 1.0
        emailTF.layer.shadowRadius = 0.0
        
        phoneTF.text = User.phone
        emailTF.text = User.business_email
        webSiteTF.text = User.web_site
    }
}
