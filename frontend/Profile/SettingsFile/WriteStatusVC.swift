//
//  writeStatusVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 19/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

extension WriteStatusVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (statusTF.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 128
    }
    
    func textViewDidChange(_ textView: UITextView) {
        numberOfChractersLabel.text = String(128  - statusTF.text.count)
    }
}

class WriteStatusVC: UIViewController {
    
    @IBOutlet weak var statusTF: UITextView!
    @IBOutlet weak var writeStatusNavBar: UINavigationItem!
    @IBOutlet weak var numberOfChractersLabel: UILabel!
    
    var doneButton = UIButton()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        statusTF.delegate = self
        
        statusTF.text = User.status
        statusTF.becomeFirstResponder()
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        doneButton.addTarget(self, action: #selector(dismissNavController), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)        
    }
    
    @objc func dismissNavController() {
        if InternetConnection.isConnectedToNetwork() {
            Database.uploadUserStatus(user_status: statusTF.text!, user_email: User.email)
            User.status = statusTF.text!
            UserDefaults.standard.set(User.status, forKey: "USER_STATUS")
        }
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        navigationItem.title = User.language.status
        view.backgroundColor = currentTheme.backgroundColor
        statusTF.textColor = currentTheme.textColor
        statusTF.backgroundColor = currentTheme.backgroundSeparatorColor
        statusTF.keyboardAppearance = currentTheme.keyboardLook
        numberOfChractersLabel.textColor = currentTheme.textColor
        numberOfChractersLabel.text = String(128  - statusTF.text.count)
    }
}

