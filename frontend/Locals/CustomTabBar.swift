//
//  CustomTabBar.swift
//  eventsProject
//
//  Created by Pietro Putelli on 24/10/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

enum TabbarItemTag: Int {
    case home = 101
    case top = 102
    case profile = 103
}

enum StoryboardID: String {
    case home = "Home"
    case topArea = "TopArea"
    case profile = "Profile"
}

class CustomTabBarController: UITabBarController {
    
    var homeImageView: UIView!
    var topImageView: UIView!
    var profileImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        
        let homeView = tabBar.subviews.first!
        homeImageView = homeView.subviews.first
        homeImageView.contentMode = .center

        let topView = tabBar.subviews[1]
        topImageView = topView.subviews.first
        topImageView.contentMode = .center

        let profileView = tabBar.subviews[2]
        profileImageView = profileView.subviews.first
        profileImageView.contentMode = .center
    }
    
    func setUpViews() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let topAreaStoryboard = UIStoryboard(name: "TopArea", bundle: nil)
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HOME_NC")
        let topAreaVC = topAreaStoryboard.instantiateViewController(withIdentifier: "TOP_NC")
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "PROFILE_NC")

        viewControllers = [homeVC,topAreaVC,profileVC]
    }
    
    private func animate(_ imageView: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabbarItemTag = TabbarItemTag(rawValue: item.tag) else {
            return
        }
        
        switch tabbarItemTag {
        case .home:
            self.animate(homeImageView)
        case .top:
            self.animate(topImageView)
        case .profile:
            self.animate(profileImageView)
        }
    }
}
