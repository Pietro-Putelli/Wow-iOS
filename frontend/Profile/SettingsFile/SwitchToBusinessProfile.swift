//
//  SwitchToBusinessProfile.swift
//  eventsProject
//
//  Created by Pietro Putelli on 31/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class SwitchToBusinessProfile1: UIViewController {
    
    @IBOutlet weak var explaiLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow").withRenderingMode(.automatic)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        explaiLabel.textColor = currentTheme.textColor
        continueButton.backgroundColor = currentTheme.separatorColor
        continueButton.setTitleColor(currentTheme.backgroundColor, for: .normal)
        continueButton.layer.cornerRadius = continueButton.frame.size.width / 12
    }
}

class SwitchToBusinessProfile2: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow").withRenderingMode(.automatic)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        infoTextView.backgroundColor = currentTheme.backgroundSeparatorColor
        infoTextView.textColor = currentTheme.textColor
        infoTextView.keyboardAppearance = currentTheme.keyboardLook
        infoTextView.becomeFirstResponder()
        infoTextView.delegate = self
        continueButton.backgroundColor = currentTheme.separatorColor
        continueButton.setTitleColor(currentTheme.backgroundColor, for: .normal)
        continueButton.layer.cornerRadius = continueButton.frame.size.width / 16
        continueButton.isEnabled = false
    }
}

extension SwitchToBusinessProfile2: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.trimmingCharacters(in: .whitespaces).isEmpty) { continueButton.isEnabled = false }
        else { continueButton.isEnabled = true }
    }
}

class SwitchToBusinessProfile3: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var webSiteTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func chekNumberOfCharacters(_ sender: UITextField) {
        if (sender.text?.isEmailAddress)! {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let navigationController1 = mainStoryboard.instantiateViewController(withIdentifier: "profileSettingsVCID") as! ProfileSettingsTVC
        self.performSegue(withIdentifier: "showProfileID", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow").withRenderingMode(.automatic)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        let shadowColor = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1)
        let textFields = [emailTF,phoneTF,webSiteTF]
        let placeholdes = ["Email","Phone number (optional)","Web site (optional)"]
        
        for i in 0..<textFields.count {
            let textField = textFields[i]
            textField?.borderStyle = .none
            textField?.layer.backgroundColor = currentTheme.backgroundColor.cgColor
            textField?.layer.shadowColor = shadowColor.cgColor
            textField?.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
            textField?.layer.shadowOpacity = 1.0
            textField?.layer.shadowRadius = 0.0
            textField?.attributedPlaceholder = NSAttributedString(string: placeholdes[i],attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            textField?.keyboardAppearance = currentTheme.keyboardLook
            textField?.textColor = currentTheme.textColor
        }
        let email = UserDefaults.standard.value(forKey: "USER_EMAIL") as! String
        emailTF.becomeFirstResponder()
        emailTF.text = email
        emailTF.addTarget(self, action: #selector(chekNumberOfCharacters), for: .editingChanged)
        continueButton.backgroundColor = currentTheme.separatorColor
        continueButton.setTitleColor(currentTheme.backgroundColor, for: .normal)
        continueButton.layer.cornerRadius = continueButton.frame.size.width / 16
    }
}









