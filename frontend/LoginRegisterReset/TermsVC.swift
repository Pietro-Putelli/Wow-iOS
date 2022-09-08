//
//  TermsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 31/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import WebKit

class TermsVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://finixinc.com/website/privacy_policy.html"
        let requestURL = NSURL(string: url)
        let request = URLRequest(url: requestURL! as URL)
        
        webView.load(request)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
