//
//  MyProfileTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 17/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ProfilePictureCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    @IBOutlet weak var followButtonOutlet: UIButton!
}

class ProfileAboutTitleCell: UITableViewCell {
    @IBOutlet weak var aboutLabel: UILabel!
}

class ProfileStatusCell: UITableViewCell {
    @IBOutlet weak var statusContentLabel: UILabel!
}

class ProfileMyEventsCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var eventsTitleLabel: UILabel!
}

class ProfileContactsTitleCell: UITableViewCell {
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var topSeparator: UIView!
}

class ProfileContactsCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contactTitleLabel: UILabel!
}

class ProfileLastCell: UITableViewCell {
    @IBOutlet weak var bottomSeparator: UIView!
}
