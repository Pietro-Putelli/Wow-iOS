//
//  FavouritesTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 04/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class TopAreaVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchController: CustomSegmenteControl!

    var isEvent = Bool()
    var isAlreadyLoaded = Bool()
    
    var userLocation = CLLocationCoordinate2D()
    
    let refreshControl = UIRefreshControl()
    var locationManager = CLLocationManager()
    
    var fav_events = [Int]()
    var going_events = [Int]()
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var connectionErrorBackgorundView = UIView()
    var connectionErrorActivityIndicator: NVActivityIndicatorView!
    var connectionErrorBacgroundLabelView: UIView!
    var connectionErrorLabel: UILabel!
    
    var emptyAlertViewHome = EmptyAlertViewHome()
    
    var previousController: UIViewController?
    
    var const = Int()
    
    let reachability = Reachability()
    
    var selectedLocal: Local!
    var locals = [Local]()
    
    var selectedEvent: Event!
    var events = [Event]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        tabBarItem.tag = TabbarItemTag.top.rawValue
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        if let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as? Int {
            currentTheme = themes[themeIndex]
        }

        switchController.addTarget(self, action: #selector(segmentedControlChanged(sender:)), for: .valueChanged)

        refreshControl.addTarget(self, action: #selector(setupLocationManager), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        emptyAlertViewHome = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_home_id, owner: self, options: nil)?.first as! EmptyAlertViewHome
        emptyAlertViewHome.center = view.center
        
        self.setCollectionViewFlowLayout()
        self.setScreenSwipeGesture()
        self.presentLoadView()
        self.setupLocationManager()
        self.checkReachability()
    }
    
    @objc func internetConnectionDidChange(_ sender: Notification) {
        let reachability = sender.object as! Reachability
        
        if reachability.connection != .none {
            DispatchQueue.main.async {
                self.removeConnectionError()
                self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
            }
        } else {
            DispatchQueue.main.async {
                self.presentConnectionError()
            }
        }
    }
    
    func checkReachability() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnectionDidChange(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        
        do {
            try reachability?.startNotifier()
        } catch {}
        
        reachability!.whenReachable = {_ in
            DispatchQueue.main.async {
                self.removeConnectionError()
            }
        }
        
        reachability!.whenUnreachable = {_ in
            DispatchQueue.main.async {
                self.presentConnectionError()
            }
        }
    }
    
    func presentConnectionError() {
        if !connectionErrorBackgorundView.isDescendant(of: view) {
            let connectionErrorView = LoadingView.connectionErrorLoadingView(for: view)
            
            connectionErrorBackgorundView = connectionErrorView.activityIndicatorBackground
            connectionErrorActivityIndicator = connectionErrorView.activityIndicator
            connectionErrorBacgroundLabelView = connectionErrorView.errorLabelBackground
            connectionErrorLabel = connectionErrorView.errorLabel
            
            view.addSubview(connectionErrorBackgorundView)
            view.addSubview(connectionErrorActivityIndicator)
            view.addSubview(connectionErrorBacgroundLabelView)
            view.addSubview(connectionErrorLabel)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeConnectionError() {
        if connectionErrorBackgorundView.isDescendant(of: view) {
            connectionErrorBackgorundView.removeFromSuperview()
            connectionErrorActivityIndicator.removeFromSuperview()
            connectionErrorBacgroundLabelView.removeFromSuperview()
            connectionErrorLabel.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    func presentLoadView() {
        loadingView = LoadingView.homeLoadingView(for: view)
        backgroundLoadView = loadingView.backgroundView
        activityIndicator = loadingView.activityIndicator
        view.addSubview(backgroundLoadView)
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    func removeLoadView() {
        backgroundLoadView.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    @objc func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func reloadDataFromDB(latitudeFrom: Double, longitudeFrom: Double) {
        emptyAlertViewHome.removeFromSuperview(view: view)
        if !isEvent {
            Database.getTopLocals(latitudeFrom: latitudeFrom, longitudeFrom: longitudeFrom, const: const) { (json) in
                DispatchQueue.main.async {
                    self.locals = JSON.parseArrayLocal(json: json)
                    self.collectionView.reloadData()
                    self.removeLoadView()
                    
                    if self.locals.isEmpty && !self.emptyAlertViewHome.isDescendant(of: self.view) {
                        self.emptyAlertViewHome.alertLabel.text = User.language.empty_local
                        self.view.addSubview(self.emptyAlertViewHome)
                    }
                }
            }
        } else {
            Database.getTopEvents(latitudeFrom: latitudeFrom, longitudeFrom: longitudeFrom, const: const) { (json) in
                DispatchQueue.main.async {
                    self.events = JSON.parseArrayEvent(json: json)
                    self.collectionView.reloadData()
                    self.removeLoadView()
                    
                    if self.events.isEmpty && !self.emptyAlertViewHome.isDescendant(of: self.view) {
                        self.emptyAlertViewHome.alertLabel.text = User.language.empty_event
                        self.view.addSubview(self.emptyAlertViewHome)
                    }
                }
            }
        }
    }
    
    @objc func segmentedControlChanged(_ sender: AnyObject?) {
        if switchController.selectedIndex == 0 { isEvent = false } else { isEvent = true }
        if isEvent { switchController.selectedIndex = 1 } else { switchController.selectedIndex = 0 }
        
        collectionView.reloadData()
        self.presentLoadView()
        self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
    }
    
    func setScreenSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(screenEdgePanGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(screenEdgePanGesture(_:)))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func screenEdgePanGesture(_ sender: UISwipeGestureRecognizer) {
        if switchController.selectedIndex == 0 && sender.direction == .left {
            isEvent = true
            switchController.selectedIndex = 1
            self.segmentedControlChanged(nil)
        } else if switchController.selectedIndex == 1 && sender.direction == .right {
            isEvent = false
            switchController.selectedIndex = 0
            self.segmentedControlChanged(nil)
        }
    }
    
    @objc func segmentedControlChanged(sender: AnyObject?) {
        if switchController.selectedIndex == 0 { isEvent = false } else { isEvent = true }
        if isEvent { switchController.selectedIndex = 1 } else { switchController.selectedIndex = 0 }
        
        collectionView.reloadData()
        self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
    }
    
    func setCollectionViewFlowLayout() {
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2
        let insetY = insetX / 2
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = cellWidth
        collectionView.contentInset = UIEdgeInsetsMake(insetY, insetX, insetY, insetX)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalTVC,
            let indexPath = collectionView.indexPathsForSelectedItems {
            destination.selectedLocal = locals[indexPath[0].item]
        }
        
        if let destination = segue.destination as? EventsTVC,
            let indexPath = collectionView.indexPathsForSelectedItems {
            destination.selectedEvent = events[indexPath[0].item]
            destination.fav_events = fav_events
            destination.going_events = going_events
        }
        
        if let indexPath = collectionView.indexPathsForSelectedItems {
            collectionView.deselectItem(at: indexPath[0], animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        switchController.items = [User.language.locals,User.language.events]
        switchController.font = UIFont(name: "Accuratist", size: 16)
        
        switchController.borderColor = currentTheme.separatorColor
        switchController.selectedLabelColor = currentTheme.backgroundColor
        switchController.thumbColor = currentTheme.separatorColor
        switchController.unselectedLabelColor = currentTheme.textColor
        
        Database.handleEventArray(email: User.email, url: PHP.DOMAIN + PHP.FAV_EVENTS_GET) { (fav_events) in
            DispatchQueue.main.async {
                self.fav_events = fav_events
            }
        }
        
        Database.handleEventArray(email: User.email, url: PHP.DOMAIN + PHP.GOING_EVENTS_GET) { (going_events) in
            DispatchQueue.main.async {
                self.going_events = going_events
            }
        }
        
        navigationItem.title = User.language.top_area
        navigationController?.navigationBar.tintColor = currentTheme.barColor
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO.withSize(18), font_2: FONTS.ACCURATIST)
        
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
        collectionView.reloadData()
        
        if let measureUnit = UserDefaults.standard.value(forKey: "USER_MEASURE_UNIT") as? Int {
            const = CONST.getConst(measureUnit: measureUnit)
        }
        collectionView.reloadData()
        self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO.withSize(18), font_2: FONTS.ACCURATIST)
    }
}

extension TopAreaVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isEvent { return locals.count }
        else { return events.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isEvent {
            selectedLocal = locals[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocalCell
            cell.backgroundColor = currentTheme.backgroundColor
            
            cell.layer.cornerRadius = cell.frame.width / 32
            cell.layer.shadowRadius = 5
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowOffset = CGSize(width: 5, height: 10)
            cell.clipsToBounds = true
            
            cell.coveImageView.layer.masksToBounds = true
            cell.coveImageView.clipsToBounds = true
            cell.titleLabel.text = selectedLocal.title
            cell.placeLabel.text = selectedLocal.city
            cell.timetableLabel.text = "Open"
            cell.titleLabel.text = selectedLocal.title
            
            cell.titleLabel.textColor = currentTheme.textColor
            cell.placeLabel.textColor = currentTheme.textColor
            cell.timetableLabel.textColor = currentTheme.textColor
            cell.reviewLabel.textColor = currentTheme.textColor
            
            cell.ratingView.backgroundColor = .clear
            cell.ratingView.contentMode = .scaleAspectFit
            cell.ratingView.emptyImage = #imageLiteral(resourceName: "emptyStar")
            cell.ratingView.fullImage = #imageLiteral(resourceName: "fullyStar")
            cell.ratingView.rating = selectedLocal.rating
            
            if selectedLocal.numberOfReviews == 1 {
                cell.reviewLabel.text = String(selectedLocal.numberOfReviews) + " " + User.language.review
            } else {
                cell.reviewLabel.text = String(selectedLocal.numberOfReviews) + " " + User.language.reviews
            }
            
            let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")
            
            Database.getImage(withURL: imageURL!) { (image) in
                DispatchQueue.main.async {
                    cell.coveImageView.image = image
                }
            }
            return cell
        }
            
        else {
            
            selectedEvent = events[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! EventCell
            cell.backgroundColor = currentTheme.backgroundColor
            
            cell.layer.cornerRadius = cell.frame.width / 32
            cell.layer.shadowRadius = 5
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowOffset = CGSize(width: 5, height: 10)
            cell.clipsToBounds = true
            
            cell.coverImageView.layer.masksToBounds = true
            cell.coverImageView.clipsToBounds = true
            cell.titleLabel.text = selectedEvent.title
            cell.placeLabel.text = selectedEvent.city
            cell.timetableLabel.text = selectedEvent.fromDate
            
            cell.titleLabel.textColor = currentTheme.textColor
            cell.placeLabel.textColor = currentTheme.textColor
            cell.timetableLabel.textColor = currentTheme.textColor
            
            cell.likes.textColor = currentTheme.textColor
            cell.going.textColor = currentTheme.textColor
            cell.likes.text = String(selectedEvent.likes)
            cell.going.text = String(selectedEvent.going)
            
            let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedEvent.owner)/userEvents/\(selectedEvent.owner)\(selectedEvent.id!)/coverImg.jpg")
            
            Database.getImage(withURL: imageURL!) { (image) in
                DispatchQueue.main.async {
                    cell.coverImageView.image = image
                }
            }
            return cell
        }
    }
}

extension TopAreaVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopMonitoringSignificantLocationChanges()
        if let userLocation: CLLocationCoordinate2D = manager.location?.coordinate {
            self.reloadDataFromDB(latitudeFrom: userLocation.latitude, longitudeFrom: userLocation.longitude)
            self.locationManager.stopUpdatingLocation()
            self.refreshControl.endRefreshing()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension TopAreaVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let viewController1 = navVC.viewControllers.first as? TopAreaVC {
                if viewController1.isViewLoaded && viewController1.view.window != nil {
                    viewController1.scrollToTop()
                }
            }
        }
        previousController = viewController
        return true
    }
}
