//
//  SettingsTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 03/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

class ProfileSettingsCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePicture.layer.borderWidth = 0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
    }
}

class NotificationSettingsCell: UITableViewCell {
    @IBOutlet weak var notificationsTitleLabel: UILabel!
}

class AppearanceSettingsCell: UITableViewCell {
    @IBOutlet weak var appearanceTitleLabel: UILabel!
}

class LanguageSettingsCell: UITableViewCell {
    @IBOutlet weak var languageTitleLabel: UILabel!
    @IBOutlet weak var currentLanguageLabel: UILabel!
}

class UnitsSettingsCell: UITableViewCell {
    @IBOutlet weak var unitsTitleLabel: UILabel!
}

class ManualSettingsCell: UITableViewCell {
    @IBOutlet weak var manulTitleLabel: UILabel!
}

class InformationAboutFinixCell: UITableViewCell {
    @IBOutlet weak var informationFinixTitle: UILabel!
}

class InfoCell: UITableViewCell {
    @IBOutlet weak var instagram: UIButton!
    @IBOutlet weak var web_site: UIButton!
    @IBOutlet weak var email: UIButton!
}
