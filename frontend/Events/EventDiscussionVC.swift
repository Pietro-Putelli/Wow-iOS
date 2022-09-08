//
//  LocalReviewVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 21/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class MainDiscussionCell: UICollectionViewCell {
    var dropMenu: UIAlertController!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var titile_label: UILabel!
    @IBOutlet weak var content_text_view: UITextView!
    @IBOutlet weak var reply_button: UIButton!
    @IBOutlet weak var answers_button: UIButton!
    @IBOutlet weak var date_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = CGFloat(ceil(size.height))
        frame.size.width = UIScreen.main.bounds.width - 20
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}

class EventDiscussionVC: UIViewController {
    
    @IBOutlet weak var discussion_button: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    
    var selectedEventID: Int!
    
    var discussions = [Discussion]()
    var selectedDiscussion: Discussion!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.setCollectionViewFlowLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventWriteDiscussionVC {
            destination.selectedEventID = selectedEventID
        }
        if let destination = segue.destination as? DiscussionReplyesVC {
            destination.selectedDiscussion = selectedDiscussion
            destination.selectedEventID = selectedEventID
        }
    }
    
    @IBAction func discussionButtonAction(_ sender: UIButton) {
        sender.pulse()
    }
    
    func setupDropMenu(sender: UIButton) {
        if let cell = collectionView.cellForItem(at: [0,sender.tag]) as? MainDiscussionCell {
            cell.dropMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancel = UIAlertAction(title: User.language.cancel, style: .cancel) { (_) in
                cell.dropMenu.dismiss(animated: true, completion: nil)
            }
            
            let report = UIAlertAction(title: User.language.report, style: .default) { (_) in
                Database.sendReportEmail(id: self.selectedDiscussion.id, type: 3)
            }
            
            let remove = UIAlertAction(title: User.language.delete_review, style: .default) { (_) in
                Database.deleteDiscussion(discussion_id: self.selectedDiscussion.id)
                Database.downloadEventDiscussion(event_id: self.selectedEventID, completion: { (json) in
                    DispatchQueue.main.async {
                        self.discussions = JSON.parseDiscussion(rootObject: json)
                        self.collectionView.reloadData()
                    }
                })
            }
            
            let selectedDiscussion = discussions[sender.tag]
            
            cell.dropMenu.view.tintColor = UIColor.black
            cell.dropMenu.addAction(cancel)
            cell.dropMenu.addAction(report)
            
            if User.email == selectedDiscussion.email {
                cell.dropMenu.addAction(remove)
            }
            self.present(cell.dropMenu, animated: true, completion: nil)
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.setupDropMenu(sender: sender)
    }
    
    @objc func reloadData() {
        Database.downloadEventDiscussion(event_id: selectedEventID) { (json) in
            DispatchQueue.main.async {
                self.discussions = JSON.parseDiscussion(rootObject: json)
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setCollectionViewFlowLayout() {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = insetX / 2
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = cellWidth
        layout.estimatedItemSize = CGSize(width: cellWidth, height: 50)
        collectionView.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.discussions
        
        self.reloadData()
        
        discussion_button.layer.cornerRadius = discussion_button.frame.height / 2
        discussion_button.setTitle(User.language.write_review, for: .normal)
        discussion_button.setTitleColor(currentTheme.backgroundColor, for: .normal)
        discussion_button.backgroundColor = currentTheme.separatorColor
        discussion_button.setTitle(User.language.start_discussion, for: .normal)
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
    }
}

extension EventDiscussionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        selectedDiscussion = discussions[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DISCUSSION_CELL", for: indexPath) as! MainDiscussionCell
        
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
        
        cell.username_label.text = selectedDiscussion.username
        cell.titile_label.text = selectedDiscussion.title
        cell.content_text_view.text = selectedDiscussion.content
        
        cell.answers_button.setTitleColor(currentTheme.textColor, for: .normal)
        cell.answers_button.setTitle(User.language.view_reply, for: .normal)
        
        cell.menu.setImage(#imageLiteral(resourceName: "menu2").withRenderingMode(.alwaysTemplate), for: .normal)
        cell.menu.tintColor = currentTheme.textColor
        cell.menu.tag = indexPath.row
        
        cell.date_label.textColor = currentTheme.textColor
        cell.date_label.text = selectedDiscussion.date
        
        let url = URL(string: "https://finixinc.com/usersAccountData/\(selectedDiscussion.email)/profilePicture.jpg")
        
        Database.downloadImage(withURL: url!) { (image) in
            DispatchQueue.main.async {
                cell.image.image = image
            }
        }
        return cell
    }
}
