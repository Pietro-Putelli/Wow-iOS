//
//  LocalWriteDetailsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

extension LocalWriteDetailsVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).count < 32 { doneButton.isEnabled = false } else { doneButton.isEnabled = true }
    }
}

class LocalWriteDetailsVC: UIViewController {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var detailsContentTV: UITextView!
    
    var doneButton = UIButton()
    
    var details: String?
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(dismissWriteDetails), for: .touchUpInside)
        
        if let details = details {
            detailsContentTV.text = details
            if details.trimmingCharacters(in: .whitespaces).count < 32 {
                doneButton.isEnabled = false
            } else {
                doneButton.isEnabled = true
            }
        } else {
            doneButton.isEnabled = false
        }
    }
    
    @objc func dismissWriteDetails() {
        UserDefaults.standard.set(detailsContentTV.text, forKey: "LOCAL_DETAILS")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.add_details
        
        detailsContentTV.backgroundColor = currentTheme.backgroundSeparatorColor
        detailsContentTV.textColor = currentTheme.textColor
        detailsContentTV.keyboardAppearance = currentTheme.keyboardLook
        detailsContentTV.delegate = self
        detailsContentTV.becomeFirstResponder()
    }
}
