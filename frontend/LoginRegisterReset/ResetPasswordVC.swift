//
//  ResetPasswordView.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var isEmailAlreadySent = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
                
        let placeholderTextColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 0.5)

        emailTF.makeBottomBorder()
        emailTF.borderStyle = .none
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter email address",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])

        resetButton.layer.cornerRadius = self.resetButton.frame.size.width / 8
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    func writeError(error: String) {
        emailTF.shakeTextField()
        errorLabel.text = error
    }

    func okAnimation() {
        let green = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
        
        UIView.animate(withDuration: 0.5) {
            self.resetButton.backgroundColor = green
            self.resetButton.setTitle("OK", for: .normal)
        }
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        errorLabel.text = ""
        sender.pulse()
        view.endEditing(true)
        
        if !isEmailAlreadySent {
            if let user_email = emailTF.text {
                if !user_email.trimmingCharacters(in: .whitespaces).isEmpty && user_email.contains("@") {
                    Database.checkEmailExistence(email: user_email) { (isEmailExistes) in
                        DispatchQueue.main.async {
                            if isEmailExistes {
                                Database.resetPassword(user_email: user_email)
                                self.isEmailAlreadySent = true
                                self.okAnimation()
                            } else {
                                self.writeError(error: "Email address not found")
                            }
                        }
                    }
                } else {
                    self.writeError(error: "Invalid email address")
                }
            } else {
                self.writeError(error: "Invalid email address")
            }
        } else {
            self.performSegue(withIdentifier: "segueToLogin", sender: self)
        }
    }
}
