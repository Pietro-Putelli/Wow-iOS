//
//  MyEventsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 07/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyEventCell: UITableViewCell {
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setupbyLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class MyEventsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var deleteView: DeleteAlertView!
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    var eventAlertView = EmptyAlertView()

    var images = [UIImage]()
    var imageView = UIImageView()
    var selectedBackgorund = UIView()
    
    var isFirstSelected = Bool()
    
    var refreshControl = UIRefreshControl()
    var delegateDelete = DelegateDelete1()
    
    var selectedEvent: Event!
    var events = [Event]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        self.presentLoadView()
        
        refreshControl.addTarget(self, action: #selector(reloadDBData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        eventAlertView = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_id, owner: self, options: nil)?.first as! EmptyAlertView
    }
    
    func handleAlertView() {
        if events.isEmpty {
            eventAlertView.presentView(view: view, icon_image: #imageLiteral(resourceName: "calendar4"), label_1_text: User.language.no_events_1, label_2_text: User.language.no_events_2, label_3_text: User.language.no_events_3)
        } else if eventAlertView.isDescendant(of: view) {
            eventAlertView.removeFromSuperview()
        }
    }
    
    @objc func reloadDBData() {
        Database.getEventsByOwner(owner: User.email) { (json) in
            DispatchQueue.main.async {
                self.events = JSON.parseArrayEvent(json: json)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        sender.pulse()
        Database.delete(id: delegateDelete.selectedEvent.id!, url: PHP.DOMAIN + PHP.DELETE_EVENT)
        events.remove(at: delegateDelete.indexPathSelected.row)
        tableView.deleteRows(at: [delegateDelete.indexPathSelected], with: .automatic)
        tableView.reloadData()
        deleteView.removeDeleteAlertView(view: view)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        sender.pulse()
        deleteView.removeDeleteAlertView(view: view)
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
        if let destination = segue.destination as? CreateEventTVC,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedEvent = events[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? MyEventCell {
                destination.imageView.image = cell.coverImg.image
            }
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        selectedBackgorund.backgroundColor = currentTheme.selectedColor
        
        navigationItem.title = User.language.my_events
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)

        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        Database.getEventsByOwner(owner: User.email) { (json) in
            DispatchQueue.main.async {
                self.events = JSON.parseArrayEvent(json: json)
                self.tableView.reloadData()
                self.handleAlertView()
            }
        }
        
        UserDefaults.standard.set(nil, forKey: "FROM_DATE")
        UserDefaults.standard.set(nil, forKey: "TO_DATE")
        UserDefaults.standard.set(nil, forKey: "AT_TIME")
    }
}

extension MyEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        delegateDelete.indexPathSelected = indexPath
        delegateDelete.selectedEvent = events[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action,view,completion) in
            self.deleteView.presentDelterAlertView(view: self.view)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trash1").withRenderingMode(.alwaysTemplate)
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
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
        cell.likesLabel.text = String(selectedEvent.likes) + " likes"
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












