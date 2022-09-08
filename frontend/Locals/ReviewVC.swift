//
//  ReviewVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 09/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    var dropMenu: UIAlertController!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}

class ReviewVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    var selectedLocal: Local!
    var selectedReview: Review!
    var reviews = [Review]()
    
    var refreshControl = UIRefreshControl()
    
    var isReviewExiste = Bool()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.setCollectionViewFlowLayout()
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        sender.pulse()
    }
    
    func setCollectionViewFlowLayout() {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = insetX / 2
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = cellWidth
        layout.footerReferenceSize = CGSize(width: 0, height: 50)
        collectionView.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
    }
    
    @objc func reloadData() {
        Database.getLocalReviews(id: selectedLocal.id!) { (json) in
            DispatchQueue.main.async {
                self.reviews = JSON.parseReview(rootObject: json)
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setupDropMenu(sender: UIButton) {
        if let cell = collectionView.cellForItem(at: [0,sender.tag]) as? ReviewCell {
            cell.dropMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancel = UIAlertAction(title: User.language.cancel, style: .cancel) { (_) in
                cell.dropMenu.dismiss(animated: true, completion: nil)
            }
            
            let report = UIAlertAction(title: User.language.report, style: .default) { (_) in
                Database.sendReportEmail(id: self.selectedReview.id, type: 2)
            }
            
            let remove = UIAlertAction(title: User.language.delete_review, style: .default) { (_) in
                Database.deleteReview(user_email: User.email, local_id: self.selectedLocal.id!, rating: cell.ratingView.rating)
                Database.getLocalReviews(id: self.selectedLocal.id!, completion: { (json) in
                    DispatchQueue.main.async {
                        self.reviews = JSON.parseReview(rootObject: json)
                        self.collectionView.reloadData()
                        self.checkReviewExistence()
                    }
                })
            }
            
            let selectedReview = reviews[sender.tag]
            
            cell.dropMenu.view.tintColor = UIColor.black
            cell.dropMenu.addAction(cancel)
            cell.dropMenu.addAction(report)
            
            if User.email == selectedReview.email {
                cell.dropMenu.addAction(remove)
            }
            self.present(cell.dropMenu, animated: true, completion: nil)
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.setupDropMenu(sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalReviewVC {
            destination.selectedLocal = selectedLocal
        }
    }
    
    func checkReviewExistence() {
        Database.checkReviewExistence(user_email: User.email, local_id: selectedLocal.id!) { (isReviewExiste) in
            DispatchQueue.main.async {
                if isReviewExiste {
                    self.writeReviewButton.isEnabled = false
                } else {
                    self.writeReviewButton.isEnabled = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        self.reloadData()
        self.checkReviewExistence()
        
        writeReviewButton.layer.cornerRadius = writeReviewButton.frame.height / 2
        writeReviewButton.setTitle(User.language.write_review, for: .normal)
        writeReviewButton.setTitleColor(currentTheme.backgroundColor, for: .normal)
        writeReviewButton.backgroundColor = currentTheme.separatorColor
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
        navigationItem.title = User.language.reviews
    }
}

extension ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        selectedReview = reviews[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "REVIEW_CELL", for: indexPath) as! ReviewCell
        
        cell.backgroundColor = currentTheme.backgroundColor
        cell.layer.cornerRadius = cell.frame.width / 32
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 5, height: 10)
        cell.clipsToBounds = true
        
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width / 2
        cell.profileImage.clipsToBounds = true
        
        cell.usernameLabel.textColor = currentTheme.textColor
        cell.titleLabel.textColor = currentTheme.textColor
        cell.contentTV.textColor = currentTheme.textColor
        cell.contentTV.backgroundColor = currentTheme.backgroundColor
        
        cell.usernameLabel.text = selectedReview.username
        cell.titleLabel.text = selectedReview.title
        cell.contentTV.text = selectedReview.content
        
        cell.ratingView.backgroundColor = .clear
        cell.ratingView.contentMode = .scaleAspectFit
        cell.ratingView.emptyImage  = #imageLiteral(resourceName: "emptyStar")
        cell.ratingView.fullImage = #imageLiteral(resourceName: "fullyStar")
        cell.ratingView.rating = selectedReview.starsRating
        
        cell.menuButton.setImage(#imageLiteral(resourceName: "menu2").withRenderingMode(.alwaysTemplate), for: .normal)
        cell.menuButton.tintColor = currentTheme.textColor
        cell.menuButton.tag = indexPath.row
        
        cell.dateLabel.textColor = currentTheme.textColor
        cell.dateLabel.text = selectedReview.date
        
        let url = URL(string: "https://finixinc.com/usersAccountData/\(selectedReview.email)/profilePicture.jpg")
        
        Database.downloadImage(withURL: url!) { (image) in
            DispatchQueue.main.async {
                cell.profileImage.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight: CGFloat = 330.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
