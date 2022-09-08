//
//  ProfileSettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ProfileSettingsTVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet var logoutView: LogoutAlertView!
    
    var imageView = UIImageView()
    var imagePicker = UIImagePickerController()

    var selectedCellView = UIView()
        
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    var currentLanguage: Language! = nil
    var languages = Language.languageFromBundle()
    
    var isAlredyRegistered = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        sender.pulse()
        logoutView.removeLogoutAlertView(view: view)
        
        UserDefaults.standard.set(false, forKey: USER_KEYS.ALREADY_REGISTERED)
        Image.cleanMemory()
        
        Database.setUserLogged(user_email: User.email, user_logged: 0)
        
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstVCID")
        self.present(firstViewController, animated: true, completion: {
            UserDefaults.standard.set(nil, forKey: USER_KEYS.EMAIL)
        })
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        sender.pulse()
        logoutView.removeLogoutAlertView(view: view)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func editProfilePictureButton(_ sender: UIButton) {
        self.presentAlbum()
    }
    
    @objc func presentAlbum() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.image = image
            let img = Image.resizeImage(image: imageView.image!, targetSize: CGSize(width: 300, height: 300))
            imageView.image = img
            let url = NSURL(string: PHP.DOMAIN + PHP.USER_IMG_SET)
            Database.imageUploadRequest(imageView: imageView, uploadUrl: url!, parameters: ["folderID":User.email,"path":""], imgName: "profilePicture", completion: {_ in})
        }
        User.profile_image = imageView.image
        Image.setImage(image: imageView.image!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        logoutView.presentLogoutAlertView(view: view)
        sender.pulse()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "editProfilePictureCell", for: indexPath) as! EditProfilePictureCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.editProfilePictureButtonOutlet.setTitleColor(currentTheme.separatorColor, for: .normal)
            cell.editProfilePictureButtonOutlet.setTitle(User.language.edit_image, for: .normal)
            cell.editProfilePictureButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.profilePicture.image = User.profile_image
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "editNameCell", for: indexPath) as! EditNameCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.nameTitleLabel.textColor = currentTheme.textColor
            cell.usernameLabel.text = User.name
            cell.nameTitleLabel.text = User.language.name
            cell.usernameLabel.textColor = currentTheme.textColor
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAboutCell", for: indexPath) as! EditStatusCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.statusTitleLabel.textColor = currentTheme.textColor
            cell.statusLabel.textColor = currentTheme.textColor
            cell.statusLabel.text = User.status
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPasswordCellID", for: indexPath) as! EditPasswordCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.editPasswordTitleLabel.textColor = currentTheme.textColor
            cell.editPasswordTitleLabel.text = User.language.edit_password
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "buisnessInfoID", for: indexPath) as! AddBuisnessInfoCell
            cell.selectionStyle = .default
            cell.selectedBackgroundView = selectedCellView
            cell.backgroundColor = currentTheme.backgroundColor
            cell.buisnessInfoTitleLabel.textColor = currentTheme.textColor
            cell.buisnessInfoTitleLabel.text = User.language.business_info
            return cell
            
        case 5:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "logOutCell", for: indexPath) as! LogOutCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundSeparatorColor
            cell.logOutButton.layer.cornerRadius = cell.logOutButton.frame.height / 2
            cell.logOutButton.setTitle(User.language.log_out, for: .normal)
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]

        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.edit_profile
        
        selectedCellView.backgroundColor = currentTheme.selectedColor
        
        imagePicker.navigationBar.barStyle = .black
        imagePicker.navigationBar.barTintColor = currentTheme.barColor
        imagePicker.navigationItem.rightBarButtonItem?.tintColor = currentTheme.textColor
    }
}
