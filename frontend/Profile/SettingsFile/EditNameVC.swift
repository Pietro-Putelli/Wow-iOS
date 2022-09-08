//
//  EditNameVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 16/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class EditNameVC: UIViewController {
    
    @IBOutlet weak var editNameTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var charLabel: UILabel!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    var newUsername: String!
    
    var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
        
        if let newUsername = newUsername {
            User.name = newUsername
            UserDefaults.standard.set(User.name, forKey: USER_KEYS.NAME)
            Database.uploadUsername(user_name: User.name, user_email: User.email)
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        newUsername = sender.text!
        self.errorLabel.text = ""
        charLabel.text = String(30 - newUsername.count)
        if newUsername.trimmingCharacters(in: .whitespaces).count < 1 {
            doneButton.isEnabled = false
        } else if InternetConnection.isConnectedToNetwork() {
            Database.checkUserUniqueName(user_name: newUsername) { (isUsernameExist) in
                DispatchQueue.main.async {
                    if !isUsernameExist || User.name == self.newUsername {
                        self.doneButton.isEnabled = true
                    } else {
                        self.doneButton.isEnabled = false
                        self.editNameTF.shakeTextField()
                        self.errorLabel.text = User.language.username_exists
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.edit_name
        
        charLabel.textColor = currentTheme.textColor
        charLabel.text = String(30 - User.name.count)
        
        errorLabel.textColor = currentTheme.textColor
        
        editNameTF.borderStyle = .none
        editNameTF.textColor = currentTheme.textColor
        editNameTF.layer.backgroundColor = currentTheme.backgroundColor.cgColor
        editNameTF.layer.masksToBounds = false
        editNameTF.backgroundColor = currentTheme.backgroundColor
        editNameTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        editNameTF.layer.shadowOpacity = 1.0
        editNameTF.layer.shadowRadius = 0.0
        editNameTF.layer.shadowColor = currentTheme.textColor.cgColor
        editNameTF.attributedPlaceholder = NSAttributedString(string: User.language.name,attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        editNameTF.keyboardAppearance = currentTheme.keyboardLook
        editNameTF.becomeFirstResponder()
        editNameTF.text = User.name
        editNameTF.delegate = self
    }
}

extension EditNameVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count < 31
    }
}
