//
//  LoginView.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginView: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var facebookLoginButton: LoadingButton!
    
    var isUserExists = Bool()
    var isAlredyRegisted = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        loginButton.layer.cornerRadius = loginButton.frame.width / 8
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.width / 14
        view.layer.cornerRadius = view.frame.width / 64
        
        let placeholderTextColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 0.5)
        
        usernameTF.makeBottomBorder()
        usernameTF.delegate = self
        usernameTF.borderStyle = .none
        usernameTF.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
        
        passwordTF.makeBottomBorder()
        passwordTF.delegate = self
        passwordTF.borderStyle = .none
        passwordTF.isSecureTextEntry = true
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        sender.pulse()
        
        if (usernameTF.text?.isEmpty)! || !(usernameTF.text?.contains("@"))! {
            
            shakeTextField(textField: usernameTF)
            alertLabel.text = "Invalid email"
        } else if (passwordTF.text?.isEmpty)! {
            
            shakeTextField(textField: passwordTF)
        }
        
        if !(usernameTF.text?.isEmpty)! && !(passwordTF.text?.isEmpty)! && (usernameTF.text?.contains("@"))! {
            
            if InternetConnection.isConnectedToNetwork() == true {
                
                alertLabel.text = ""
                loginButton.showLoading()
                
                Database.downloadUserData(email: usernameTF.text!, password: passwordTF.text!) { (json) in
                    DispatchQueue.main.async {
                        if !json.isEmpty {
                            self.parseUserJSON(json: json)
                            self.presentHomeVC()
                        } else {
                            self.alertLabel.text = "Invalid email or password"
                            self.loginButton.hideLoading()
                        }
                    }
                }
            } else {
                alertLabel.text = "No internet connection"
            }
        }
    }
    
    func parseUserJSON(json: [String:AnyObject]) {
        
        if  let id = json["id"] as? String,
            let username = json["username"] as? String,
            let email = json["email"] as? String,
            let password = json["password"] as? String {
            
            if let status = json["status"] as? String,
                let business_email = json["business_email"] as? String,
                let phone = json["phone"] as? String,
                let web_site = json["web_site"] as? String {
                    
                    UserDefaults.standard.set(status, forKey: USER_KEYS.STATUS)
                    UserDefaults.standard.set(business_email, forKey: USER_KEYS.BUSINESS_EMAIL)
                    UserDefaults.standard.set(phone, forKey: USER_KEYS.PHONE)
                    UserDefaults.standard.set(web_site, forKey: USER_KEYS.WEB_SITE)
            }
            
            UserDefaults.standard.set(id, forKey: USER_KEYS.ID)
            UserDefaults.standard.set(username, forKey: USER_KEYS.NAME)
            UserDefaults.standard.set(email, forKey: USER_KEYS.EMAIL)
            UserDefaults.standard.set(password, forKey: USER_KEYS.PASSWORD)
            UserDefaults.standard.set(true, forKey: USER_KEYS.ALREADY_REGISTERED)
            UserDefaults.standard.set([], forKey: USER_KEYS.NOTIFICATIONS)
            
            Database.setUserLogged(user_email: email, user_logged: 1)
        }
    }
    
    func presentHomeVC() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAB_BAR")
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    func shakeTextField(textField: UITextField) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: textField.center.x - 10, y: textField.center.y)
        animation.toValue = CGPoint(x: textField.center.x + 10, y: textField.center.y)
        
        textField.layer.add(animation, forKey: "position")
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginButton.showLoading()
        loginButton.hideLoading()
    }
}

extension LoginView {
    
    @IBAction func loginFacebookAction(sender: LoadingButton) {
        sender.pulse()
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)!{
                    return
                }
                if (fbloginresult.grantedPermissions.contains("email")) {
                    self.facebookLoginButton.showLoading()
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    
                    let jsonData = result as! [String:AnyObject]
                    
                    if let email = jsonData["email"] as? String,
                        let username = jsonData["name"] as? String,
                        let password = jsonData["id"] as? String,
                        let imgDataJSON = jsonData["picture"]!["data"] as? [String:AnyObject] {
                        
                        Database.checkEmailExistence(email: email, completionHandler: { (emailExiste) in
                            DispatchQueue.main.async {
                                
                                let imageView = UIImageView()
                                let uploadURL = NSURL(string: PHP.DOMAIN + PHP.USER_IMG_SET)
                                
                                if let imgURL = imgDataJSON["url"] as? String {
                                    imageView.setImageFromURl(stringImageUrl: imgURL)
                                }
                                
                                Database.imageUploadRequest(imageView: imageView, uploadUrl: uploadURL!, parameters: ["folderID":email,"path":""], imgName: "profilePicture",completion: {_ in})
                                
                                if emailExiste {
                                    Database.downloadUserData(email: email, password: password, completionHandler: { (json) in
                                        DispatchQueue.main.async {
                                            self.parseUserJSON(json: json)
                                            self.presentHomeVC()
                                        }
                                    })
                                } else {
                                    Database.uploadUserRegisterData(username: username, email: email, password: password)
                                    Database.downloadUserData(email: email, password: password, completionHandler: { (json) in
                                        DispatchQueue.main.async {
                                            self.parseUserJSON(json: json)
                                            self.presentHomeVC()
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
            })
        }
    }
}
