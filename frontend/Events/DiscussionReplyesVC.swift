//
//  DiscussionReplyesVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 18/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ReplyDiscussionCell: UICollectionViewCell {
    var dropMenu: UIAlertController!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var titile_label: UILabel!
    @IBOutlet weak var content_text_view: UITextView!
}

class DiscussionReplyesVC: UIViewController {
    
    @IBOutlet weak var reply_button: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedEventID: Int!
    var selectedDiscussion: Discussion!
    
    var selectedReply: Discussion!
    var answers = [Discussion]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
    }
    
    @objc func reloadData() {
        Database.downloadEventDiscussionAnswer(discussion_id: selectedDiscussion.id) { (json) in
            DispatchQueue.main.async {
                self.answers = JSON.parseDiscussion(rootObject: json)
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupDropMenu(sender: UIButton) {
        if let cell = collectionView.cellForItem(at: [0,sender.tag]) as? ReplyDiscussionCell {
            cell.dropMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancel = UIAlertAction(title: User.language.cancel, style: .cancel) { (_) in
                cell.dropMenu.dismiss(animated: true, completion: nil)
            }
            
            let report = UIAlertAction(title: User.language.report, style: .default) { (_) in
                Database.sendReportEmail(id: self.selectedReply.id, type: 4)
            }
            
            let remove = UIAlertAction(title: User.language.delete_review, style: .default) { (_) in
                Database.deleteEventDiscussionReply(user_email: User.email, discussion_id: self.selectedDiscussion.id, answer_id: self.selectedReply.id)
                
                Database.downloadEventDiscussionAnswer(discussion_id: self.selectedDiscussion.id, completion: { (json) in
                    DispatchQueue.main.async {
                        self.answers = JSON.parseDiscussion(rootObject: json)
                        self.collectionView.reloadData()
                    }
                })
            }
            
            let selectedReply = answers[sender.tag]
            
            cell.dropMenu.view.tintColor = UIColor.black
            cell.dropMenu.addAction(cancel)
            cell.dropMenu.addAction(report)
            
            if User.email == selectedReply.email {
                cell.dropMenu.addAction(remove)
            }
            self.present(cell.dropMenu, animated: true, completion: nil)
        }
    }
    
    @IBAction func dropMenuAction(_ sender: UIButton) {
        self.setupDropMenu(sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventWriteDiscussionVC {
            destination.selectedDiscussion = selectedDiscussion
            destination.selectedEventID = selectedEventID
        }
    }
    
    @IBAction func replyButton(_ sender: UIButton) {
        sender.pulse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        self.reloadData()
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        navigationItem.title = User.language.answer_to + " " + selectedDiscussion.username
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
        
        reply_button.layer.cornerRadius = reply_button.frame.height / 2
        reply_button.setTitle(User.language.write_review, for: .normal)
        reply_button.setTitleColor(currentTheme.backgroundColor, for: .normal)
        reply_button.backgroundColor = currentTheme.separatorColor
        reply_button.setTitle(User.language.reply, for: .normal)
    }
}

extension DiscussionReplyesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        selectedReply = answers[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "REPLY_CELL", for: indexPath) as! ReplyDiscussionCell
        
        cell.backgroundColor = currentTheme.backgroundColor
        cell.layer.cornerRadius = cell.frame.width / 32
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 5, height: 10)
        cell.clipsToBounds = true
        
        cell.image.layer.masksToBounds = false
        cell.image.layer.cornerRadius = cell.image.frame.width / 2
        cell.image.clipsToBounds = true
        
        cell.username_label.textColor = currentTheme.textColor
        cell.titile_label.textColor = currentTheme.textColor
        cell.content_text_view.textColor = currentTheme.textColor
        cell.content_text_view.backgroundColor = currentTheme.backgroundColor
        
        cell.username_label.text = selectedReply.username
        cell.titile_label.text = selectedReply.title
        cell.content_text_view.text = selectedReply.content
        
        cell.menu.setImage(#imageLiteral(resourceName: "menu2").withRenderingMode(.alwaysTemplate), for: .normal)
        cell.menu.tintColor = currentTheme.textColor
        cell.menu.tag = indexPath.row
        
        let url = URL(string: "https://finixinc.com/usersAccountData/\(selectedReply.email)/profilePicture.jpg")
        
        Database.downloadImage(withURL: url!) { (image) in
            DispatchQueue.main.async {
                cell.image.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight: CGFloat = 250.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

