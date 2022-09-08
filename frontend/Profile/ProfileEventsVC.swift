//
//  ProfileEventsVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/12/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileEventsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedBackgorund = UIView()
    
    var images = [UIImage]()
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var selectedOwner: Friend!
    var selectedEvent: Event!
    var events = [Event]()
    
    var eventAlertView = EmptyAlertView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        self.presentLoadView()
        
        eventAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    func handleAlertView() {
        if events.isEmpty {
            eventAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "calendar4"), label_1_text: User.language.no_events_1, label_2_text: "", label_3_text: "")
        } else if eventAlertView.isDescendant(of: view) {
            eventAlertView.removeFromSuperview()
        }
    }
    
    func presentLoadView() {
        if !backgroundLoadView.isDescendant(of: view) {
            loadingView = LoadingView.homeLoadingView(for: view)
            backgroundLoadView = loadingView.backgroundView
            activityIndicator = loadingView.activityIndicator
            view.addSubview(backgroundLoadView)
            view.addSubview(activityIndicator)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeLoadView() {
        if backgroundLoadView.isDescendant(of: view) {
            backgroundLoadView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventsTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedEvent = events[indexPath.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        navigationItem.title = User.language.event_list
        
        selectedBackgorund.backgroundColor = currentTheme.selectedColor
        
        Database.getEventsByOwner(owner: selectedOwner.email) { (json) in
            DispatchQueue.main.async {
                self.events = JSON.parseArrayEvent(json: json)
                self.tableView.reloadData()
                self.handleAlertView()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
    }
}

extension ProfileEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        selectedEvent = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as! MyEventCell
        cell.backgroundColor = currentTheme.backgroundColor
        cell.selectedBackgroundView = selectedBackgorund
        
        cell.titleLabel.textColor = currentTheme.textColor
        cell.setupbyLabel.textColor = currentTheme.textColor
        cell.likesLabel.textColor = currentTheme.textColor
        cell.dateLabel.textColor = currentTheme.textColor
        
        cell.titleLabel.text = selectedEvent.title
        cell.setupbyLabel.text = selectedEvent.setUpBy
        cell.likesLabel.text = String(selectedEvent.likes) + " " + User.language.like
        cell.dateLabel.text = "\(selectedEvent.fromDate) - \(selectedEvent.toDate)"
        
        cell.coverImg.layer.cornerRadius = cell.coverImg.frame.size.width / 16
        cell.coverImg.layer.masksToBounds = true
        
        let downloadURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedEvent.owner)/userEvents/\(selectedEvent.owner)\(selectedEvent.id!)/coverImg.jpg")
        
        Database.downloadImage(withURL: downloadURL!) { (image) in
            DispatchQueue.main.async {
                if let image = image {
                    self.images.append(image)
                    cell.coverImg.image = image
                } else {
                    self.images.append(UIImage())
                }
                
                if self.images.count < self.events.count {
                    self.presentLoadView()
                } else {
                    self.removeLoadView()
                }
            }
        }
        return cell
    }
}
