//
//  RegisterView.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class VerifyAccountVC: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Hey \(username) welcome to WoW!"
        okButton.layer.cornerRadius = okButton.frame.size.width / 8
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        sender.pulse()
    }
}

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerButton: LoadingButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        let placeholderTextColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 0.5)
        
        usernameTF.makeBottomBorder()
        usernameTF.borderStyle = .none
        usernameTF.attributedPlaceholder = NSAttributedString(string: "Username",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
        usernameTF.delegate = self
        
        emailTF.makeBottomBorder()
        emailTF.borderStyle = .none
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
        
        passwordTF.makeBottomBorder()
        passwordTF.borderStyle = .none
        passwordTF.isSecureTextEntry = true
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
        passwordTF.delegate = self
        
        registerButton.layer.cornerRadius = self.registerButton.frame.size.width / 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VerifyAccountVC {
            destination.username = usernameTF.text!
        }
    }
    
    @IBAction func joinAndAccept(_ sender: UIButton) {
        
        sender.pulse()
        registerButton.showLoading()
        
        if (usernameTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.shakeTextField(textField: usernameTF);
            errorLabel.text = "Invalid username"
            registerButton.hideLoading()
        }
    
        else if !(emailTF.text?.isEmailAddress)! {
            self.shakeTextField(textField: emailTF)
            errorLabel.text = "Invalid email address"
            registerButton.hideLoading()
        }
        
        else if (passwordTF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.shakeTextField(textField: passwordTF)
            errorLabel.text = "Invalid password"
            registerButton.hideLoading()
        }
            
        else if (passwordTF.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil) {
            self.shakeTextField(textField: passwordTF)
            errorLabel.text = "Password can't contains spaces"
            registerButton.hideLoading()
        }
        
        else if ((passwordTF.text?.count)! < 8) {
            self.shakeTextField(textField: passwordTF)
            errorLabel.text = "Password must contains at leat 8 characters"
            registerButton.hideLoading()
        } else {
        
            errorLabel.text = ""
            
            Database.checkEmailExistence(email: emailTF.text!) { (result) in
                DispatchQueue.main.async {
                    if !result {
                        if InternetConnection.isConnectedToNetwork() {
                            Database.checkUserUniqueName(user_name: self.usernameTF.text!, completion: { (isUsernameExist) in
                                DispatchQueue.main.async {
                                    if !isUsernameExist {
                                        Database.uploadUserRegisterData(username: self.usernameTF.text!, email: self.emailTF.text!, password: self.passwordTF.text!)
                                        self.performSegue(withIdentifier: "showID", sender: nil)
                                    } else {
                                        self.errorLabel.text = "Username already exists!"
                                        self.registerButton.hideLoading()
                                    }
                                }
                            })
                        } else {
                            self.errorLabel.text = "No internet connection"
                            self.registerButton.hideLoading()
                        }
                    } else {
                        self.errorLabel.text = "Email already registered!"
                        self.registerButton.hideLoading()
                    }
                }
            }
        }
    }

    func shakeTextField(textField:UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: textField.center.x - 10, y: textField.center.y)
        animation.toValue = CGPoint(x: textField.center.x + 10, y: textField.center.y)
        
        textField.layer.add(animation, forKey: "position")
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count < 31
    }
}
