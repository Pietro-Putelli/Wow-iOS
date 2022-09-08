//
//  EventsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 25/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventsTVC: UITableViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    
    var dropUpMenu = UIAlertController()
    var backgroundImage: UIImageView!
    
    var headerView = UIView()
    let kTableHeaderHeight:CGFloat = 200
    var isExpanded = Bool()
    
    var fav_events = [Int]()
    var going_events = [Int]()
    
    var isGoingSelected = Bool()
    var isEventLiked = Bool()
    
    var likes = Int()
    var going = Int()
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    var selectedCellColor = UIView()
    var imageView = UIImageView()
    
    var barImages = [UIImage]()
    var eventDescriptionCell = EventDetailsCell()
    var eventLikeGoingShareCell = EventLikeGoingShareCell()
    
    var menuButton: UIButton!
    
    var selectedOwner: Friend!
    
    var selectedLocal: Local!
    var selectedEvent: Event!
    var events = [Event]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuButton.setImage(#imageLiteral(resourceName: "menu2").withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.tintColor = .white
        menuButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuButton.addTarget(self, action: #selector(presentDropUpMenu), for: .touchUpInside)
        
        self.setupDropmenu()
        
        barImages = [#imageLiteral(resourceName: "darkBar"),#imageLiteral(resourceName: "darBlueBar"),#imageLiteral(resourceName: "classicBar")]
        
        headerView = tableView.tableHeaderView!
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.tableHeaderView?.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        self.updateHeaderView()
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        likes = selectedEvent.likes
        going = selectedEvent.going
        
        Database.getFriendByEmail(user_email: selectedEvent.owner) { (json) in
            DispatchQueue.main.async {
                self.selectedOwner = JSON.parseFriend(json: json)
            }
        }
    }
    
    func setupDropmenu() {
        dropUpMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: User.language.cancel, style: .cancel) { (_) in
            self.dropUpMenu.dismiss(animated: true, completion: nil)
        }
        dropUpMenu.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: User.language.report, style: .default) { (_) in
            Database.sendReportEmail(id: self.selectedEvent.id!, type: 1)
        }
        dropUpMenu.addAction(reportAction)
        
        let profileAction = UIAlertAction(title: User.language.view_owner_profile, style: .default) { (_) in
            self.performSegue(withIdentifier: "profile_segue_1", sender: self)
        }
        dropUpMenu.addAction(profileAction)
    }
    
    func downloadImages() {
        let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedEvent.owner)/userEvents/\(selectedEvent.owner)\(selectedEvent.id!)/coverImg.jpg")!
        if let image = Database.cache.object(forKey: imageURL.absoluteString as NSString) {
            coverImageView.image = image
        } else {
            Database.getImage(withURL: imageURL) { (image) in
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                    self.backgroundImage.image = image
                    self.tableView.backgroundView = self.backgroundImage
                }
            }
        }
    }
    
    @IBAction func presentDropUpMenu() {
        self.present(dropUpMenu, animated: true, completion: nil)
    }
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)

        if tableView.contentOffset.y < -kTableHeaderHeight {

            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }

        headerView.frame = headerRect
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    @IBAction func expandDetailDescription(_ sender: UIButton) {
        tableView.beginUpdates()
        eventDescriptionCell.eventDescriptionLabel.numberOfLines = 80
        eventDescriptionCell.eventDescriptionLabel.lineBreakMode = .byWordWrapping
        eventDescriptionCell.showButtonOutlet.isHidden = true
        tableView.endUpdates()
    }
    
    @IBAction func goingButtonAction(_ sender: UIButton) {
        if !isGoingSelected {
            
            eventLikeGoingShareCell.goingIcon.alpha = 0
            
            UIView.animate(withDuration: 0.4) {
                self.eventLikeGoingShareCell.goingIcon.alpha = 1
                self.eventLikeGoingShareCell.goingIcon.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            }
            isGoingSelected = !isGoingSelected
            
            Database.handleEventGoing(user_id: User.email, event_id: selectedEvent.id!, url: PHP.DOMAIN + PHP.EVENT_GOING_ADD)
            going += 1
            eventLikeGoingShareCell.goingNumberLabel.text = String(going)
            
            let message_content = Notifications.setForNewEvent(user_name: User.name, event_name: selectedEvent.title)
            Database.sendEventGoingNotification(user_id: User.email, event_id: selectedEvent.id!
                , message_content: message_content)
            
        } else {
            
            eventLikeGoingShareCell.goingIcon.alpha = 0
            
            UIView.animate(withDuration: 0.4) {
                self.eventLikeGoingShareCell.goingIcon.alpha = 1
                self.eventLikeGoingShareCell.goingIcon.setImage(#imageLiteral(resourceName: "going"), for: .normal)
            }
            isGoingSelected = !isGoingSelected
            
            Database.handleEventGoing(user_id: User.email,event_id: selectedEvent.id!, url: PHP.DOMAIN + PHP.EVENT_GOING_REMOVE)
            going -= 1
            eventLikeGoingShareCell.goingNumberLabel.text = String(going)
        }
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if !isEventLiked {
            
            eventLikeGoingShareCell.likeIcon.setImage(#imageLiteral(resourceName: "fullyHeart"), for: .normal)
            self.animateButton(button: eventLikeGoingShareCell.likeIcon)
            isEventLiked = !isEventLiked
            
            Database.handleFavEvents(user_id: User.email, event_id: selectedEvent.id!, url: PHP.DOMAIN + PHP.FAV_EVENT_ADD)
            
            likes += 1
            eventLikeGoingShareCell.likeNumberLabel.text = String(likes)
            
            let message_content = Notifications.setForEventLike(user_name: User.name, event_name: selectedEvent.title)
            Database.sendEventGoingNotification(user_id: User.email, event_id: selectedEvent.id!, message_content: message_content)
            
        } else {
            
            eventLikeGoingShareCell.likeIcon.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
            isEventLiked = !isEventLiked
            
            Database.handleFavEvents(user_id: User.email, event_id: selectedEvent.id!, url: PHP.DOMAIN + PHP.FAV_EVENT_REMOVE)
            likes -= 1
            eventLikeGoingShareCell.likeNumberLabel.text = String(likes)
        }
    }
    
    @IBAction func getDirection(_ sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(selectedEvent.address) { (placemarks, error) in
            
        guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.selectedEvent.title
            mapItem.openInMaps(launchOptions: options)
        }
    }

    func animateButton(button: UIButton) {
        let zoomInOut = CABasicAnimation(keyPath: "transform.scale")
        zoomInOut.fromValue = 1.0; zoomInOut.toValue = 1.2
        zoomInOut.duration = 0.4; zoomInOut.repeatCount = 1
        zoomInOut.autoreverses = true; zoomInOut.speed = 2.0
        button.layer.add(zoomInOut, forKey: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedLocal = selectedLocal {
            if let destination = segue.destination as? LocalTVC {
                destination.selectedLocal = selectedLocal
                destination.profileImage = imageView
            }
        }
        if let destination = segue.destination as? EventMapVC {
            destination.event_title = selectedEvent.title
            destination.address = selectedEvent.address
        }
        if let destination = segue.destination as? EventDiscussionVC {
            destination.selectedEventID = selectedEvent.id!
        }
        if let destination = segue.destination as? MyProfileTVC {
            destination.selectedFriend = selectedOwner
        }
    }
    
    func generateShortDate(from_date: String, to_date: String) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        
        guard let date1 = dateFormatter1.date(from: from_date), let date2 = dateFormatter1.date(from: to_date) else { fatalError() }
    
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMM"
        
        let from_date_short = dateFormatter2.string(from: date1)
        let to_date_short = dateFormatter2.string(from: date2)
        let date = "\(from_date_short)-\(to_date_short)"
        
        return date
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 && selectedLocal != nil {
            self.performSegue(withIdentifier: "segueToLocalTVC", sender: nil)
        }
        else if indexPath.row == 10 {
            if let url = URL(string: "tel://\(selectedEvent.phone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 11 {
            let settingsUrl = NSURL(string: selectedEvent.webSite!)! as URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else if indexPath.row == 12 {
            let url = NSURL(string: selectedEvent.ticket!)! as URL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if indexPath.row == 13 {
            if let url = URL(string: "mailto:\(selectedEvent.email!)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 && (selectedEvent.vip?.isEmpty)! { return 0 }
        else if indexPath.row == 8 && (selectedEvent.price?.isEmpty)! { return 0 }
        else if indexPath.row == 11 && (selectedEvent.webSite?.isEmpty)! { return 0 }
        else if indexPath.row == 12 && (selectedEvent.ticket?.isEmpty)! { return 0 }
        else if indexPath.row == 13 && (selectedEvent.email?.isEmpty)! { return 0 }
        else if indexPath.row == 16 && (selectedEvent.parking?.isEmpty)! { return 0 }
        else if indexPath.row == 17 && (selectedEvent.publicTransport?.isEmpty)! { return 0 }
        else if indexPath.row == 18 && (selectedEvent.near?.isEmpty)! { return 0 }
        else if indexPath.row == 19 && (selectedEvent.info?.isEmpty)! { return 0 }
        else { return UITableViewAutomaticDimension }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventTitleCellID", for: indexPath) as! EventTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.eventTitleLabel.textColor = currentTheme.textColor
            cell.eventTitleLabel.text = selectedEvent.title
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventDataCellID", for: indexPath) as! EventDataPlaceCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.dataTitleLabel.textColor = currentTheme.textColor
            cell.dataSubtitleLabel.textColor = currentTheme.textColor
            cell.dataTitleLabel.text = self.generateShortDate(from_date: selectedEvent.fromDate, to_date: selectedEvent.toDate)
            cell.dataSubtitleLabel.text = " \(selectedEvent.fromDate) - \(selectedEvent.toDate) - \(selectedEvent.atDate)"
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! EventPlaceCell
            cell.selectionStyle = .default
            cell.backgroundColor = .clear
            cell.selectedBackgroundView = selectedCellColor
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.placeTitleLabel.textColor = currentTheme.textColor
            cell.placeTitleLabel.text = selectedEvent.setUpBy
            cell.placeSubtitleLabel.textColor = currentTheme.textColor
            cell.placeSubtitleLabel.text = selectedEvent.address
            return cell
            
        case 3:
            
            eventLikeGoingShareCell = tableView.dequeueReusableCell(withIdentifier: "likeGoingSharesCellID", for: indexPath) as! EventLikeGoingShareCell
            eventLikeGoingShareCell.selectionStyle = .none
            eventLikeGoingShareCell.backgroundColor = .clear
            eventLikeGoingShareCell.going_background_view.layer.cornerRadius = eventLikeGoingShareCell.frame.width / 32
            eventLikeGoingShareCell.like_background_view.layer.cornerRadius = eventLikeGoingShareCell.frame.width / 32
            eventLikeGoingShareCell.going_background_view.backgroundColor = currentTheme.backgroundColor
            eventLikeGoingShareCell.like_background_view.backgroundColor = currentTheme.backgroundColor
            
            eventLikeGoingShareCell.goingIcon.layer.cornerRadius = eventLikeGoingShareCell.frame.size.width / 2
            eventLikeGoingShareCell.goingTitleLabel.textColor = currentTheme.textColor
            eventLikeGoingShareCell.goingNumberLabel.textColor = currentTheme.textColor
            eventLikeGoingShareCell.goingTitleLabel.text = User.language.going
            eventLikeGoingShareCell.likeTitleLabel.text = User.language.like
            eventLikeGoingShareCell.goingNumberLabel.text = String(going)
            eventLikeGoingShareCell.goingTitleLabel.sizeToFit()

            eventLikeGoingShareCell.likeTitleLabel.textColor = currentTheme.textColor
            eventLikeGoingShareCell.likeNumberLabel.textColor = currentTheme.textColor
            eventLikeGoingShareCell.likeNumberLabel.text = String(likes)
            
            Database.checkLikeGoingEvent(user_id: User.email, event_id: selectedEvent.id!, url: PHP.FAV_EVENT_CHECK) { (isFavourite) in
                DispatchQueue.main.async {
                    self.isEventLiked = isFavourite
                    if isFavourite {
                        self.eventLikeGoingShareCell.likeIcon.setImage(#imageLiteral(resourceName: "fullyHeart"), for: .normal)
                    } else {
                        self.eventLikeGoingShareCell.likeIcon.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
                    }
                }
            }
            
            Database.checkLikeGoingEvent(user_id: User.email, event_id: selectedEvent.id!, url: PHP.GOING_EVENT_CHECK) { (isGoing) in
                DispatchQueue.main.async {
                    self.isGoingSelected = isGoing
                    if isGoing {
                        self.eventLikeGoingShareCell.goingIcon.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                    } else {
                        self.eventLikeGoingShareCell.goingIcon.setImage(#imageLiteral(resourceName: "going"), for: .normal)
                    }
                }
            }
            
            
            return eventLikeGoingShareCell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTitleCellID", for: indexPath) as! EventDetailsTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.eventDetailsTitleLabel.textColor = currentTheme.textColor
            cell.eventDetailsTitleLabel.text = User.language.details
            return cell
            
        case 5:
            
            eventDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellID", for: indexPath) as! EventDetailsCell
            eventDescriptionCell.selectionStyle = .none
            eventDescriptionCell.backgroundColor = .clear
            eventDescriptionCell.backgorund_view.layer.cornerRadius = eventDescriptionCell.frame.width / 32
            eventDescriptionCell.backgorund_view.backgroundColor = currentTheme.backgroundColor
            eventDescriptionCell.eventDescriptionLabel.textColor = currentTheme.textColor
            eventDescriptionCell.showButtonOutlet.setTitleColor(currentTheme.separatorColor, for: .normal)
            eventDescriptionCell.showButtonOutlet.backgroundColor = eventDescriptionCell.backgroundColor
            eventDescriptionCell.showButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(3, 4, 4, 3)
            return eventDescriptionCell
            
        case 6,7,8:
            
            let icons = [#imageLiteral(resourceName: "music2"),#imageLiteral(resourceName: "vip1"),#imageLiteral(resourceName: "dollar1")]
            let titles = [selectedEvent.music,selectedEvent.vip,selectedEvent.price]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCellID", for: indexPath) as! EventSpecificInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.backgorund_view.layer.cornerRadius = cell.frame.width / 32
            cell.backgorund_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLbael.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 6]
            cell.titleLbael.text = titles[indexPath.row - 6]
            return cell
            
        case 9:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactTitleCellID", for: indexPath) as! EventContactTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.contactTitleLabel.textColor = currentTheme.textColor
            cell.contactTitleLabel.text = User.language.contacts
            return cell
            
        case 10,11,12,13:
            
            let icons = [#imageLiteral(resourceName: "phone1"),#imageLiteral(resourceName: "webSite1"),#imageLiteral(resourceName: "ticket1"),#imageLiteral(resourceName: "email1")]
            let titles = [selectedEvent.phone,"Web site","Tickes","Write email"]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactUsCellID", for: indexPath) as! EventContactCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLabel.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 10]
            cell.titleLabel.text = titles[indexPath.row - 10]
            return cell
            
        case 14:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionInfoTitleCellID", for: indexPath) as! EventPositionInfoTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.positionInfoTitleLabel.textColor = currentTheme.textColor
            cell.positionInfoTitleLabel.text = User.language.place_info
            return cell
            
        case 15:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionInfoCellID", for: indexPath) as! EventPositionInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            
            cell.map.isUserInteractionEnabled = true
            cell.map.clipsToBounds = true
            
            let legalMapLabel = cell.map.subviews[1]
            legalMapLabel.isHidden = true
            
            cell.directionTitleLabel.textColor = currentTheme.textColor
            cell.getDirectionButtonOutlet.setTitleColor(currentTheme.backgroundColor, for: .normal)
            cell.getDirectionButtonOutlet.backgroundColor = currentTheme.separatorColor
            cell.getDirectionButtonOutlet.layer.cornerRadius = cell.getDirectionButtonOutlet.frame.width / 8
            cell.getDirectionButtonOutlet.setTitle(User.language.get_direction, for: .normal)
            
            cell.directionTitleLabel.textColor = currentTheme.textColor
            cell.directionTitleLabel.text = selectedEvent.address
            
            let address = selectedEvent.address
            UserDefaults.standard.set(address, forKey: "EVENT_ADDRESS")
            UserDefaults.standard.set(selectedEvent.title, forKey: "EVENT_TITLE")
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    print(error!.localizedDescription)
                    return
                }
                
                let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
                cell.map.setRegion(region, animated: true)
                cell.map.isZoomEnabled = false
                cell.map.isScrollEnabled = false
                cell.map.isPitchEnabled = false
                cell.map.isRotateEnabled = false
                
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                let marker = MKPointAnnotation()
                marker.coordinate = location.coordinate
                cell.map.addAnnotation(marker)
            }
            
            return cell
            
        case 16,17,18,19:
            
            let icons = [#imageLiteral(resourceName: "parking1"),#imageLiteral(resourceName: "bus1"),#imageLiteral(resourceName: "near1"),#imageLiteral(resourceName: "info")]
            let titles = [selectedEvent.parking,selectedEvent.publicTransport,selectedEvent.near,selectedEvent.info]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCellKID", for: indexPath) as! EventMoreInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLabel.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 16]
            cell.titleLabel.text = titles[indexPath.row - 16]
            return cell
            
        case 20:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "discussionTitleCellID", for: indexPath) as! EventDiscussionTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.discussionTitleLabel.textColor = currentTheme.textColor
            return cell
            
        case 21:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "discussionsTitleCellID", for: indexPath) as! EventWriteDiscussionCell
            cell.selectionStyle = .default
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.selectedBackgroundView = selectedCellColor
            cell.writeDiscussionTitleLabel.textColor = currentTheme.textColor
            cell.writeDiscussionTitleLabel.text = User.language.write_review
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func viewDidLayoutSubviews() {
        headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: view.frame.width / 32)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.separatorColor = .clear
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        selectedCellColor.layer.cornerRadius = view.frame.width / 32
        
        self.downloadImages()
        
        backgroundImage = UIImageView(image: coverImageView.image)
        backgroundImage.frame = tableView.frame
        backgroundImage.addBlurEffect(style: .dark)
        tableView.backgroundView = backgroundImage
        
        navigationController?.navigationBar.setBackgroundImage(barImages[themeIndex], for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = selectedEvent.title
        
        dropUpMenu.view.tintColor = .black
        
        Database.getEventLikesGoing(event_id: selectedEvent.id!) { (array) in
            DispatchQueue.main.async {
                self.going = array[0]
                self.likes = array[1]
                self.tableView.reloadData()
            }
        }
        
        Database.downloadLocalsByID(id: selectedEvent.local_id) { (json) in
            self.selectedLocal = JSON.parseSingleLocal(json: json)
        
            if let selectedLocal = self.selectedLocal {
                let imageURL = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")
                
                Database.getImage(withURL: imageURL!) { (image) in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}

