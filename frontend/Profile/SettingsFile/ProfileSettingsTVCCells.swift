//
//  ProfileSettingsTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class EditProfilePictureCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var editProfilePictureButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
    }
}

class EditNameCell: UITableViewCell {
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
}

class EditStatusCell: UITableViewCell {
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
}

class EditPasswordCell: UITableViewCell {
    @IBOutlet weak var editPasswordTitleLabel: UILabel!
}

class AddBuisnessInfoCell: UITableViewCell {
    @IBOutlet weak var buisnessInfoTitleLabel: UILabel!
}

class LogOutCell: UITableViewCell {
    @IBOutlet weak var logOutButton: UIButton!
}

