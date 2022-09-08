//
//  FirstVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 21/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.width / 8
        registerButton.layer.cornerRadius = registerButton.frame.size.width / 8
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        sender.pulse()
    }
}
