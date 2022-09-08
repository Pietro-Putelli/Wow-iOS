//
//  EditPasswordVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 19/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class EditPasswordVC: UIViewController {
    
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var navbarItem: UINavigationItem!
    
    var doneButton = UIButton()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        doneButton.addTarget(self, action: #selector(endEditButton(_sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        currentPasswordTF.borderStyle = .none
        currentPasswordTF.layer.backgroundColor = UIColor.white.cgColor
        currentPasswordTF.layer.masksToBounds = false
        currentPasswordTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        currentPasswordTF.layer.shadowOpacity = 1.0
        currentPasswordTF.layer.shadowRadius = 0.0
        currentPasswordTF.becomeFirstResponder()
        
        newPasswordTF.borderStyle = .none
        newPasswordTF.layer.backgroundColor = UIColor.white.cgColor
        newPasswordTF.layer.masksToBounds = false
        newPasswordTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        newPasswordTF.layer.shadowOpacity = 1.0
        newPasswordTF.layer.shadowRadius = 0.0
        
        confirmPasswordTF.borderStyle = .none
        confirmPasswordTF.layer.backgroundColor = UIColor.white.cgColor
        confirmPasswordTF.layer.masksToBounds = false
        confirmPasswordTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        confirmPasswordTF.layer.shadowOpacity = 1.0
        confirmPasswordTF.layer.shadowRadius = 0.0
    }
    
    @objc func endEditButton(_sender: UIButton) {
        self.editPassword(current_pass_tf: currentPasswordTF, confirm_pass_tf: confirmPasswordTF, new_pass_tf: newPasswordTF)
    }
    
    @objc func editPassword(current_pass_tf: UITextField, confirm_pass_tf: UITextField, new_pass_tf: UITextField) {
        
        let currentPassword = current_pass_tf.text!
        let confirmPassword = confirm_pass_tf.text!
        let newPassword = new_pass_tf.text!
    
        if currentPassword.isEmpty {
            current_pass_tf.shakeTextField()
        } else if confirmPassword.isEmpty {
            confirm_pass_tf.shakeTextField()
        } else if newPassword.isEmpty {
            new_pass_tf.shakeTextField()
        } else if (newPassword.trimmingCharacters(in: .whitespaces).isEmpty) {
            alertLabel.text = "Invalid password"
        } else if (newPassword.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil) {
            alertLabel.text = "Invalid password"
        } else if ((newPassword.count) < 8) {
            alertLabel.text = "Password must contains at leat 8 characters"
        } else if newPassword != confirmPassword {
            alertLabel.text = "Password don't match"
        } else {
            if InternetConnection.isConnectedToNetwork() {

                Database.checkUserPassword(user_email: User.email, user_password: currentPassword, new_password: newPassword) { (response) in
                    print(response)
                    DispatchQueue.main.async {
                        if response {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.alertLabel.text = "Current password wrong!"
                        }
                    }
                }
            } else {
                alertLabel.text = "No internet connection"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        alertLabel.textColor = UIColor(red: 176/255, green: 32/255, blue: 14/255, alpha: 1)
        navigationItem.title = User.language.edit_password
        
        currentPasswordTF.backgroundColor = currentTheme.backgroundColor
        currentPasswordTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        currentPasswordTF.attributedPlaceholder = NSAttributedString(string: User.language.current_password,attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        currentPasswordTF.keyboardAppearance = currentTheme.keyboardLook
        currentPasswordTF.delegate = self
        currentPasswordTF.becomeFirstResponder()
        newPasswordTF.backgroundColor = currentTheme.backgroundColor
        newPasswordTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        newPasswordTF.attributedPlaceholder = NSAttributedString(string: User.language.new_password,attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        newPasswordTF.keyboardAppearance = currentTheme.keyboardLook
        newPasswordTF.delegate = self
        confirmPasswordTF.backgroundColor = currentTheme.backgroundColor
        confirmPasswordTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: User.language.confirm_password,attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        confirmPasswordTF.keyboardAppearance = currentTheme.keyboardLook
        confirmPasswordTF.delegate = self
    }
}

extension EditPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count < 31
    }
}
