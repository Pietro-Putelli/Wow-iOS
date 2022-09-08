//
//  HomeVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import MapKit
import FBAudienceNetwork

class LocalCell: UICollectionViewCell {
    @IBOutlet weak var coveImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timetableLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width / 32
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = true
    }
}

class EventCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timetableLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var going: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width / 32
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = true
    }
}

class AdsCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.width / 32
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = true
    }
}

class ExpandableView: UIView {
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override var intrinsicContentSize: CGSize {return UILayoutFittingExpandedSize }
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBarBackgroundView: UIView!
    @IBOutlet weak var switchController: CustomSegmenteControl!
    
    var locationManager = CLLocationManager()
    var refreshControl = UIRefreshControl()
    var sliderView = SliderView()
    var emptyAlertViewHome = EmptyAlertViewHome()
    
    var images = [UIImage]()
    
    var backgroundColorView = UIView()
    var hiddenYOrigin = CGFloat()
    var showedYOrigin = CGFloat()
    
    var isEvent = Bool()
    var isAlreadyLoaded = Bool()
    var isSearchBarExpanded = Bool()
    var isOpen = Bool()
    var isAlreadyConvertedToMile = Bool()
    
    var adsDensity = Int()

    var lastContentOffsetY: CGFloat = 0.0
    var const = Int()
    var measureUnitText = String()
    var cellsAlreadySetted = [UICollectionViewCell]()
    
    var latitudeFrom = CLLocationDegrees()
    var longitudeFrom = CLLocationDegrees()
    var maxDistance = Int()
    
    let reachability = Reachability()
    
    var previousController: UIViewController?
    
    var backgroundLoadView = UIView()
    var loadingView: HomeLoadingView!
    var activityIndicator: NVActivityIndicatorView! = nil
    
    var connectionErrorBackgorundView = UIView()
    var connectionErrorActivityIndicator: NVActivityIndicatorView!
    var connectionErrorBacgroundLabelView: UIView!
    var connectionErrorLabel: UILabel!
    
    var selectedLocal: Local!
    var locals = [Local]()
    
    var selectedEvent: Event!
    var events = [Event]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    var themeIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as? Int {self.themeIndex = themeIndex}
        else {UserDefaults.standard.set(0, forKey: "THEME_TYPE")}
        currentTheme = themes[themeIndex]
        
        if let userMaxDistance = UserDefaults.standard.value(forKey: "USER_MAX_DISTANCE") as? Int {
            maxDistance = userMaxDistance
        } else { maxDistance = 10 }
                
        tabBarItem.tag = TabbarItemTag.home.rawValue
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        refreshControl.addTarget(self, action: #selector(setupLocationManager), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        sliderView = Bundle.main.loadNibNamed(STORYBOARD.slider_view_id, owner: self, options: nil)?.first as! SliderView
        sliderView.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(sliderView)
        
        emptyAlertViewHome = Bundle.main.loadNibNamed(STORYBOARD.empty_alert_home_id, owner: self, options: nil)?.first as! EmptyAlertViewHome
        emptyAlertViewHome.center = view.center
        
        User.id = Int(UserDefaults.standard.value(forKey: USER_KEYS.ID) as! String)!
        User.name = UserDefaults.standard.value(forKey: USER_KEYS.NAME) as! String
        User.email = UserDefaults.standard.value(forKey: USER_KEYS.EMAIL) as! String
        User.password = UserDefaults.standard.value(forKey: USER_KEYS.PASSWORD) as! String
        User.status = UserDefaults.standard.value(forKey: USER_KEYS.STATUS) as! String
        User.notifications = UserDefaults.standard.value(forKey: USER_KEYS.NOTIFICATIONS) as! [Bool]
        User.business_email = UserDefaults.standard.value(forKey: USER_KEYS.BUSINESS_EMAIL) as! String
        User.phone = UserDefaults.standard.value(forKey: USER_KEYS.PHONE) as! String
        User.web_site = UserDefaults.standard.value(forKey: USER_KEYS.WEB_SITE) as! String
        
        adsDensity = 4
        
        tabBarController?.delegate = self
        
        self.setScreenEdgePanGestures()
        self.presentLoadView()
        self.setupLocationManager()
        self.checkReachability()
        
        if let token = UserDefaults.standard.value(forKey: USER_KEYS.TOKEN) as? String {
            Database.uploadUserDeviceToken(email: User.email, deviceToken: token)
        }
    }
    
    @objc func internetConnectionDidChange(_ sender: Notification) {
        let reachability = sender.object as! Reachability
        
        if reachability.connection != .none {
            DispatchQueue.main.async {
                self.removeConnectionError()
                self.reloadDataAsSlider()
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
    
    @objc func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func setScreenEdgePanGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(screenEdgePanGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(screenEdgePanGesture))

        swipeLeft.direction = .left
        swipeRight.direction = .right

        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }
    
    @objc func screenEdgePanGesture(_ sender: UISwipeGestureRecognizer) {
        if switchController.selectedIndex == 0 && sender.direction == .left {
            isEvent = true
            switchController.selectedIndex = 1
            self.reloadDataAsSlider()
        } else if switchController.selectedIndex == 1 && sender.direction == .right {
            isEvent = false
            switchController.selectedIndex = 0
            self.reloadDataAsSlider()
        }
    }

    func reloadDataFromDB(latitudeFrom: Double, longitudeFrom: Double) {
        emptyAlertViewHome.removeFromSuperview(view: view)
        if !isEvent {
            Database.getLocalsByCoordinate(latitudeFrom: latitudeFrom, longitudeFrom: longitudeFrom, maxDistance: Double(maxDistance), const: const) { (json) in
                DispatchQueue.main.async {
                    self.locals = JSON.parseArrayLocal(json: json)
                    self.collectionView.reloadData()
                    self.removeLoadView()
                    
                    if self.locals.isEmpty && !self.emptyAlertViewHome.isDescendant(of: self.view) {
                        self.emptyAlertViewHome.alertLabel.text = User.language.empty_local
                        self.view.addSubview(self.emptyAlertViewHome)
                    } else {
                        self.emptyAlertViewHome.removeFromSuperview(view: self.view)
                    }
                }
            }
        } else {
            Database.getEventsByCoordinate(latitudeFrom: latitudeFrom, longitudeFrom: longitudeFrom, maxDistance: Double(maxDistance), const: const) { (json) in
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
    
    @objc func segmentedControlChanged(sender: AnyObject?) {
        if switchController.selectedIndex == 0 { isEvent = false } else { isEvent = true }
        if isEvent { switchController.selectedIndex = 1 } else { switchController.selectedIndex = 0 }
        
        collectionView.reloadData()
        self.reloadDataAsSlider()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalTVC,
            let indexPath = collectionView.indexPathsForSelectedItems {
            destination.selectedLocal = locals[indexPath[0].item - Int(indexPath[0].row / adsDensity)]
        }

        if let destination = segue.destination as? EventsTVC,
            let indexPath = collectionView.indexPathsForSelectedItems {
            destination.selectedEvent = events[indexPath[0].item - Int(indexPath[0].row / adsDensity)]
        }

        if let indexPath = collectionView.indexPathsForSelectedItems {
            collectionView.deselectItem(at: indexPath[0], animated: true)
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        sliderView.radiusLabel.text = String(Int(sender.value)) + " " + measureUnitText
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if event.allTouches?.first?.phase == .ended {
            maxDistance = Int(slider.value)
            sliderView.radiusLabel.text = String(maxDistance) + " " + measureUnitText
            UserDefaults.standard.set(maxDistance, forKey: "USER_MAX_DISTANCE")
            
            self.presentLoadView()
            self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
        }
    }
    
    func reloadDataAsSlider() {
        if let maxDistance = UserDefaults.standard.value(forKey: "USER_MAX_DISTANCE") as? Int {
            self.maxDistance = maxDistance
        } else {
            maxDistance = Int(sliderView.slider.value)
        }
        
        sliderView.radiusLabel.text = String(maxDistance) + " " + measureUnitText
        UserDefaults.standard.set(maxDistance, forKey: "USER_MAX_DISTANCE")
        
        self.reloadDataFromDB(latitudeFrom: User.location.latitude, longitudeFrom: User.location.longitude)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffsetY > scrollView.contentOffset.y {
            self.presentSliderView()
        } else if lastContentOffsetY < scrollView.contentOffset.y {
            self.hideSliderView()
        }
        
        if scrollView.isAtTop {
            self.presentSliderView()
        }
        
        if scrollView.isAtBottom {
            self.hideSliderView()
        }
        
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    func hideSliderView() {
        UIView.animate(withDuration: 0.5) {
            self.sliderView.frame.origin.y = self.hiddenYOrigin
        }
    }

    func presentSliderView() {
        UIView.animate(withDuration: 0.5) {
            self.sliderView.frame.origin.y = self.showedYOrigin
        }
    }
    
    func setKm(measureUnit: Int) {
            measureUnitText = "Km"
            sliderView.slider.maximumValue = 200
            const = CONST.getConst(measureUnit: measureUnit)
            if isAlreadyConvertedToMile {
                let distance = Float(maxDistance) / CONST.CONVERT_FACTOR
                sliderView.slider.value = distance
                isAlreadyConvertedToMile = false
                UserDefaults.standard.set(distance, forKey: "USER_MAX_DISTANCE")
            } else { sliderView.slider.value = Float(maxDistance) }
            sliderView.radiusLabel.text = String(Int(sliderView.slider.value)) + " " + measureUnitText
    }
    
    func setMl(measureUnit: Int) {
        measureUnitText = "Ml"
        sliderView.slider.maximumValue = 124
        const = CONST.getConst(measureUnit: measureUnit)
        if !isAlreadyConvertedToMile {
            let distance = Float(maxDistance) * CONST.CONVERT_FACTOR
            sliderView.slider.value = distance
            isAlreadyConvertedToMile = true
            UserDefaults.standard.set(distance, forKey: "USER_MAX_DISTANCE")
        } else { sliderView.slider.value = Float(maxDistance) }
        sliderView.radiusLabel.text = String(Int(sliderView.slider.value)) + " " + measureUnitText
    }
    
    func setupAdView() -> FBAdView {
        let adView = FBAdView(placementID: FACEBOOK.PLACEMENT_ID, adSize: kFBAdSizeHeight250Rectangle, rootViewController: self)
        adView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 320, height: 250))
        adView.delegate = self
        adView.loadAd()
        
        adView.layer.masksToBounds = true
        adView.clipsToBounds = true
        
        return adView
    }
    
    func logOut() {
        UserDefaults.standard.set(false, forKey: "USER_FIRST_LOG")
        UserDefaults.standard.set(false, forKey: USER_KEYS.ALREADY_REGISTERED)
        
        let imageData:NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "profilePicturePlaceholder"))! as NSData
        UserDefaults.standard.set(imageData, forKey: "USER_PP")
        
        Database.setUserLogged(user_email: User.email, user_logged: 0)
        
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstVCID")
        self.present(firstViewController, animated: true, completion: {
            UserDefaults.standard.set(nil, forKey: USER_KEYS.EMAIL)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        backgroundColorView.backgroundColor = currentTheme.selectedColor
        switchController.tintColor = currentTheme.separatorColor
        view.backgroundColor = currentTheme.backgroundSeparatorColor
        
        navigationController?.navigationBar.tintColor = currentTheme.barColor
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO, font_2: FONTS.ACCURATIST)
        navigationItem.title = "WoW"
        
        tabBarController?.tabBar.barTintColor = currentTheme.barColor
        tabBarController?.tabBar.unselectedItemTintColor = currentTheme.notSelectedItemColor
        
        collectionView.backgroundColor = currentTheme.backgroundSeparatorColor
        
        switchController.addTarget(self, action: #selector(segmentedControlChanged(sender:)), for: .valueChanged)
        switchController.items = [User.language.locals,User.language.events]
        switchController.font = FONTS.ACCURATIST.withSize(16.0)
        
        switchController.borderColor = currentTheme.separatorColor
        switchController.selectedLabelColor = currentTheme.backgroundColor
        switchController.thumbColor = currentTheme.separatorColor
        switchController.unselectedLabelColor = currentTheme.textColor
        
        navBarBackgroundView.backgroundColor = currentTheme.navBackgroundViewColor
        
        sliderView.backgroundColor = currentTheme.backgroundColor
        let sliderViewSize = CGSize(width: view.frame.width, height: 70)
        sliderView.frame = CGRect(x: 0, y: view.frame.height - sliderViewSize.height - tabBarController!.tabBar.frame.height, width: view.frame.width, height: sliderViewSize.height)
        sliderView.roundCorners(corners: [.topLeft,.topRight], radius: view.frame.width / 32)
        sliderView.backgroundColor = currentTheme.backgroundColor.withAlphaComponent(0.9)
        
        showedYOrigin = sliderView.frame.origin.y
        hiddenYOrigin = sliderView.frame.origin.y + sliderViewSize.height
        
        sliderView.slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        sliderView.slider.minimumTrackTintColor = currentTheme.separatorColor
        sliderView.radiusLabel.textColor = currentTheme.textColor
        
        var measureUnit = UserDefaults.standard.value(forKey: "USER_MEASURE_UNIT") as? Int
        
        if measureUnit == 0 || measureUnit == nil {
            if let measureUnit = measureUnit {
                self.setKm(measureUnit: measureUnit)
            } else {
                measureUnit = 0
                UserDefaults.standard.set(0, forKey: "USER_MEASURE_UNIT")
                self.setKm(measureUnit: measureUnit!)
            }
        } else {
            self.setMl(measureUnit: measureUnit!)
        }
        
        Database.checkUserExistence(user_email: User.email) { (isUserExist) in
            DispatchQueue.main.async {
                if !isUserExist {
                    self.logOut()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.handleTitleTextAttributes(font_1: FONTS.LEIXO, font_2: FONTS.ACCURATIST)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isEvent { return locals.count + locals.count / adsDensity }
        else { return events.count + events.count / adsDensity }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellScaling: CGFloat = 0.95
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        var cellHeight = CGFloat()
        
        if indexPath.row != 0 && indexPath.row % adsDensity == 0 {
            cellHeight = 250.0
        } else {
            cellHeight = 330.0
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row % adsDensity == 0 && indexPath.row != 0 {
            return false
        } else { return true }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != 0 && indexPath.row % adsDensity == 0 && !isEvent {
            
            let adCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! AdsCell
            let adView = self.setupAdView()
            
            if !adView.isDescendant(of: adCell) {
                adCell.addSubview(adView)
                adView.center = CGPoint(x: adCell.frame.width / 2, y: adCell.frame.height / 2)
            }
            
            return adCell
            
        } else if indexPath.row != 0 && indexPath.row % adsDensity == 0 && isEvent {
            
            let adCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! AdsCell
            let adView = self.setupAdView()
            
            if !adView.isDescendant(of: adCell) {
                adCell.addSubview(adView)
                adView.center = CGPoint(x: adCell.frame.width / 2 , y: adCell.frame.height / 2)
            }
            
            return adCell
            
        } else {
            if !isEvent {
                
                selectedLocal = locals[indexPath.row - Int(indexPath.row / adsDensity)]
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocalCell
                cell.backgroundColor = currentTheme.backgroundColor
                cell.coveImageView.layer.masksToBounds = true
                cell.coveImageView.clipsToBounds = true

                let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")
                
                Database.getImage(withURL: imageURL!) { (image) in
                    DispatchQueue.main.async {
                        cell.coveImageView.image = image
                    }
                }
                
                cell.titleLabel.text = selectedLocal.title
                cell.placeLabel.text = selectedLocal.city
                
                if selectedLocal.numberOfReviews == 1 {
                    cell.reviewLabel.text = String(selectedLocal.numberOfReviews) + " " + User.language.review
                } else {
                    cell.reviewLabel.text = String(selectedLocal.numberOfReviews) + " " + User.language.reviews
                }
                
                cell.titleLabel.textColor = currentTheme.textColor
                cell.placeLabel.textColor = currentTheme.textColor
                cell.timetableLabel.textColor = currentTheme.textColor
                cell.reviewLabel.textColor = currentTheme.textColor
                
                cell.ratingView.backgroundColor = .clear
                cell.ratingView.contentMode = .scaleAspectFit
                cell.ratingView.emptyImage = #imageLiteral(resourceName: "emptyStar")
                cell.ratingView.fullImage = #imageLiteral(resourceName: "fullyStar")
                cell.ratingView.rating = selectedLocal.rating
                
                cell.timetableLabel.text = Time.getTimetable(timetable: selectedLocal.timetable)
                
                return cell
            } else {
                
                selectedEvent = events[indexPath.row - Int(indexPath.row / adsDensity)]
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! EventCell
                cell.backgroundColor = currentTheme.backgroundColor
                cell.coverImageView.layer.masksToBounds = true
                cell.coverImageView.clipsToBounds = true
                cell.titleLabel.text = selectedEvent.title
                cell.placeLabel.text = selectedEvent.city
                cell.timetableLabel.text = "\(selectedEvent.fromDate) to \(selectedEvent.toDate)"
                
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
}

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 4))
    }
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation:CLLocationCoordinate2D = manager.location?.coordinate {
            User.location = userLocation
            self.reloadDataAsSlider()
            self.refreshControl.endRefreshing()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension HomeVC: FBAdViewDelegate {
    
    func adViewDidClick(_ adView: FBAdView) {
        print("Banner ad was clicked.")
    }
    
    func adViewDidFinishHandlingClick(_ adView: FBAdView) {
        print("Banner ad did finish click handling.")
    }
    
    func adViewWillLogImpression(_ adView: FBAdView) {
        print("Banner ad impression is being captured.")
    }

    func adView(_ adView: FBAdView?) throws {
        print("Ad failed to load")
    }
    
    func adViewDidLoad(_ adView: FBAdView) {
        print("Ad was loaded and ready to be displayed")
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension HomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let viewController1 = navVC.viewControllers.first as? HomeVC {
                if viewController1.isViewLoaded && viewController1.view.window != nil {
                    viewController1.scrollToTop()
                }
            }
        }
        previousController = viewController
        return true
    }
}
