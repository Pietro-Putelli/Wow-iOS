//
//  EventWriteDiscussion.swift
//  eventsProject
//
//  Created by Pietro Putelli on 17/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class EventWriteDiscussionVC: UIViewController {
    
    @IBOutlet weak var reviewTitleTF: UITextField!
    @IBOutlet weak var reviewContentTV: UITextView!
    
    var doneButton = UIButton()
    
    var isTitleEmpty = Bool()
    var isContentEmpty = Bool()
    
    var selectedEventID: Int!
    var selectedDiscussion: Discussion!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        
        isTitleEmpty = true
        isContentEmpty = true
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        doneButton.isEnabled = false
    }
    
    func setupJSON(title: String, content: String) -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let discussion = ReviewJSON.init(title: title, content: content)
        let json = try! jsonEncoder.encode(discussion)
        let string_json = String(data: json, encoding: .utf8)!
        return string_json
    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
        
        let title = reviewTitleTF.text!
        let content = reviewContentTV.text!
        let json = self.setupJSON(title: title, content: content)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        if selectedDiscussion != nil {
            Database.uploadEventDiscussionAnswer(discussion_id: selectedDiscussion.id, user_name: User.name, user_email: User.email, date: currentDate, answer_json: json)
            let message_content = Notifications.setForReply(user_name: User.name)
            Database.sendReplyNotification(target_id: selectedDiscussion.email, event_id: selectedEventID, discussion_id: selectedDiscussion.id, message_content: message_content)
        } else {
            Database.uploadEventDiscussion(user_name: User.name, user_email: User.email, event_id: selectedEventID, date: currentDate, discussion_json: json)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        
        reviewContentTV.backgroundColor = currentTheme.backgroundSeparatorColor
        reviewContentTV.textColor = currentTheme.textColor
        reviewContentTV.keyboardAppearance = currentTheme.keyboardLook
        reviewContentTV.delegate = self
        reviewContentTV.becomeFirstResponder()
        
        reviewTitleTF.keyboardAppearance = currentTheme.keyboardLook
        reviewTitleTF.backgroundColor = currentTheme.backgroundColor
        reviewTitleTF.layer.cornerRadius = reviewTitleTF.frame.width / 64
        reviewTitleTF.backgroundColor = currentTheme.backgroundColor
        reviewTitleTF.textColor = currentTheme.textColor
        reviewTitleTF.delegate = self
        reviewTitleTF.attributedPlaceholder = NSAttributedString(string: "Review title", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        
        reviewTitleTF.borderStyle = .none
        reviewTitleTF.layer.backgroundColor = UIColor.white.cgColor
        reviewTitleTF.layer.masksToBounds = false
        reviewTitleTF.layer.shadowColor = currentTheme.separatorColor.withAlphaComponent(0.8).cgColor
        reviewTitleTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        reviewTitleTF.layer.shadowOpacity = 1.0
        reviewTitleTF.layer.shadowRadius = 0.0
        
        navigationItem.title = User.language.start_discussion
    }
}

extension EventWriteDiscussionVC: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespaces).count < 50 {
            doneButton.isEnabled = false
        } else if isTitleEmpty {
            isContentEmpty = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.trimmingCharacters(in: .whitespaces))!.count < 8 {
            doneButton.isEnabled = false
        } else if isContentEmpty {
            isTitleEmpty = false
        } else {
            doneButton.isEnabled = true
        }
    }
}
