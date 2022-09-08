//
//  WriteDetailsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 29/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

extension EventWriteDetailsVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).count < 32 {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
}

class EventWriteDetailsVC: UIViewController {
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var detailsContentTV: UITextView!
    
    var doneButton = UIButton()
    
    var details: String?
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        if let details = details {

            detailsContentTV.text = details
            
            if (details.trimmingCharacters(in: .whitespaces).count) < 32 {
                doneButton.isEnabled = false
            } else {
                doneButton.isEnabled = true
            }
        }
    }
    
    @objc func doneButtonAction() {
        UserDefaults.standard.set(detailsContentTV.text!, forKey: "EVENT_DETAILS")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]

        view.backgroundColor = currentTheme.backgroundColor
        
        detailsContentTV.backgroundColor = currentTheme.backgroundSeparatorColor
        detailsContentTV.textColor = currentTheme.textColor
        detailsContentTV.keyboardAppearance = currentTheme.keyboardLook
        navigationItem.title = User.language.add_details
        
        let detailsContent = UserDefaults.standard.value(forKey: "EVENT_DETAILS") as? String
        if detailsContent != nil {detailsContentTV.text = detailsContent}
        
        detailsContentTV.becomeFirstResponder()
        detailsContentTV.delegate = self
    }
}






