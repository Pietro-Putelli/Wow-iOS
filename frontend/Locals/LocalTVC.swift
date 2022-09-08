//
//  LocalTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 22/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit

class LocalTVC: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    var dropUpMenu = UIAlertController()
    
    let kTableHeaderHeight:CGFloat = 250.0
    var headerView = UIView()
    var isExpanded = Bool()
    var isTimeTableExpanded = Bool()
    var barImages = [UIImage]()

    let selectedCellColor = UIView()
    var backgroundImage: UIImageView!
    
    var addToFavouritesButton = UIButton()
    var shareButton = UIButton()
    
    var isLocalLiked = Bool()
    var isLocalAddedToFavourites = Bool()
    var isLocalOpen = Bool()
    
    var likes = Int()
    
    var localDetailsCell = LocalDetailsCell()
    var localDaysWeekCell = LocalDaysWeekCell()
    var localTimeCell = LocalTimeCell()
    var localLikeFavShareCell = LocalLikeFavShareCell()
    var localSpecificInfoIconCell = LocalSpecificInfoIconCell()
    var localDaysWeekCellHeight = CGFloat()
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    var selectedReview: Review!
    var reviews = [Review]()
    
    var selectedOwner: Friend!
    
    var selectedLocal: Local!
    var locals = [Local]()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = tableView.tableHeaderView!
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.tableHeaderView?.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        profileImage.isUserInteractionEnabled = true
        self.updateHeaderView()
        
        barImages = [#imageLiteral(resourceName: "darkBar"),#imageLiteral(resourceName: "darBlueBar"),#imageLiteral(resourceName: "classicBar")]
        localDaysWeekCellHeight = 0
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        Database.getFriendByEmail(user_email: selectedLocal.owner) { (json) in
            DispatchQueue.main.async {
                self.selectedOwner = JSON.parseFriend(json: json)
            }
        }
        
        self.setupDropmenu()
    }
    
    func downloadImages() {
        let url = URL(string: "https://finixinc.com/usersAccountData/\(selectedLocal.owner)/userLocals/\(selectedLocal.owner)\(selectedLocal.id!)/coverImg.jpg")!
        print(url)
        if let image = Database.cache.object(forKey: url.absoluteString as NSString) {
            profileImage.image = image
        } else {
            Database.getImage(withURL: url) { (image) in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                    self.backgroundImage.image = image
                    self.tableView.backgroundView = self.backgroundImage
                }
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
            Database.sendReportEmail(id: self.selectedLocal.id!, type: 0)
        }
        dropUpMenu.addAction(reportAction)
        
        let ownerAction = UIAlertAction(title: User.language.view_owner_profile, style: .default) { (_) in
            self.performSegue(withIdentifier: "profile_segue", sender: self)
        }
        dropUpMenu.addAction(ownerAction)
    }
    
    override func viewDidLayoutSubviews() {
        headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: view.frame.width / 32)
    }
    
    @IBAction func presentDropUpMenu() {
        self.present(dropUpMenu, animated: true, completion: nil)
    }
    
    @objc func showPictureCollection() {
        let mainStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "localPictureCollection") as UIViewController
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
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
        
        self.updateHeaderView()
        
        let offSet = scrollView.contentOffset.y / 40
        
        if offSet > 1 {
            
            let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int            
            navigationController?.navigationBar.setBackgroundImage(barImages[themeIndex], for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.title = selectedLocal.title
            
        } else if offSet < 1 {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.title = ""
        }
    }
    
    var sectionIsExpanded: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.sectionIsExpanded {
                    self.localTimeCell.showTimetableButtonOutlet.transform = CGAffineTransform.identity
                } else {
                    self.localTimeCell.showTimetableButtonOutlet.transform = CGAffineTransform(rotationAngle: -.pi)
                }
            }
        }
    }
    
    @IBAction func expandTimetableView(_ sender: UIButton) {
        
        sectionIsExpanded = !sectionIsExpanded
        
        if !isTimeTableExpanded {
            tableView.beginUpdates()
            localDaysWeekCellHeight = 160
            tableView.endUpdates()
            isTimeTableExpanded = !isTimeTableExpanded
        }
            
        else if isTimeTableExpanded {
            tableView.beginUpdates()
            localDaysWeekCellHeight = 0
            tableView.endUpdates()
            isTimeTableExpanded = !isTimeTableExpanded
        }
    }
    
    @IBAction func showMoreButton(_ sender: UIButton) {
        tableView.beginUpdates()
        localDetailsCell.localDetailsContentLabel.numberOfLines = 80
        localDetailsCell.localDetailsContentLabel.lineBreakMode = .byWordWrapping
        localDetailsCell.showMoreButtonOutlet.isHidden = true
        tableView.endUpdates()
    }
    
    @IBAction func getDirection(_ sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(selectedLocal.address) { (placemarks, error) in
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.selectedLocal.title
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    @IBAction func addToFavouritesButton(_ sender: UIButton) {
        if !isLocalAddedToFavourites {
            
            localLikeFavShareCell.likeIcon.setImage(#imageLiteral(resourceName: "fullyHeart"), for: .normal)
            localLikeFavShareCell.likeIcon.zoomIn()
            isLocalAddedToFavourites = !isLocalAddedToFavourites

            Database.handleFavLocals(user_id: User.email, local_id: selectedLocal.id!, url: PHP.DOMAIN + PHP.FAV_LOCAL_ADD)
            likes += 1
            localLikeFavShareCell.numberOfLikeLabel.text = String(likes)
        } else {
            localLikeFavShareCell.likeIcon.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
            isLocalAddedToFavourites = !isLocalAddedToFavourites
            
            Database.handleFavLocals(user_id: User.email, local_id: selectedLocal.id!, url: PHP.DOMAIN + PHP.FAV_LOCAL_REMOVE)
            likes -= 1
            localLikeFavShareCell.numberOfLikeLabel.text = String(likes)
        }
    }

    func addQuickInfo(array: [Int]) {
        for index in array {
            switch index {
            case 0:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "parking1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Parking")
            case 1:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "wifi"))
                localSpecificInfoIconCell.collectionViewTitles.append("Free wifi")
            case 2:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "music2"))
                localSpecificInfoIconCell.collectionViewTitles.append("Music")
            case 3:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "tv"))
                localSpecificInfoIconCell.collectionViewTitles.append("TV")
            case 4:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "place1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Outside sitting")
            case 5:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "sport1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Sport")
            case 6:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "games1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Games")
            case 7:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "slot"))
                localSpecificInfoIconCell.collectionViewTitles.append("Slot")
            case 8:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "kids1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Good for kids")
            case 9:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "cocktail1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Coktails")
            case 10:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "food1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Food")
            case 11:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "cake2"))
                localSpecificInfoIconCell.collectionViewTitles.append("Birthday")
            case 12:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "pizza1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Take away food")
            case 13:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "wine1"))
                localSpecificInfoIconCell.collectionViewTitles.append("Food and wine")
            case 14:
                localSpecificInfoIconCell.collectionViewIcons.append(#imageLiteral(resourceName: "dog"))
                localSpecificInfoIconCell.collectionViewTitles.append("Pets friendly")
            default: break
            }
        }
    }
    
    func getDateFormat(dateString: String) -> String {
        
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "hh:mm a"
        
        if let _ = inFormatter.date(from: dateString) { return "hh:mm a" }
        else { return "HH:mm" }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalReviewVC {
            destination.selectedLocal = selectedLocal
        }
        if let destination = segue.destination as? LocalPictureCVC {
            destination.selectedLocal = selectedLocal
        }
        if let destination = segue.destination as? LocalEventListVC {
            destination.selectedLocal = selectedLocal
        }
        if let destination = segue.destination as? LocalMapVC {
            destination.address = selectedLocal.address
            destination.local_title = selectedLocal.title
        }
        if let destination = segue.destination as? ReviewVC {
            destination.selectedLocal = selectedLocal
        }
        if let destination = segue.destination as? MyProfileTVC {
            destination.selectedFriend = selectedOwner
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8 {
            self.performSegue(withIdentifier: "eventListID", sender: nil)
        } else if indexPath.row == 13 {
            if let url = URL(string: "tel://\(selectedLocal.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 14 {
            let settingsUrl = NSURL(string: selectedLocal.webSite!)! as URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else if indexPath.row == 15 {
            if let url = URL(string: "mailto:\(selectedLocal.email!)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 { return localDaysWeekCellHeight }
        else if indexPath.row == 11 && selectedLocal.quickInfo.isEmpty { return 0 }
        else if indexPath.row == 9 && (selectedLocal.music?.isEmpty)! { return 0 }
        else if indexPath.row == 10 && (selectedLocal.place?.isEmpty)! { return 0 }
        else if indexPath.row == 14 && (selectedLocal.webSite?.isEmpty)! { return 0 }
        else if indexPath.row == 15 && (selectedLocal.email?.isEmpty)! { return 0 }
        else if indexPath.row == 18 && (selectedLocal.parkingInfo?.isEmpty)! { return 0 }
        else if indexPath.row == 19 && (selectedLocal.ptInfo?.isEmpty)! { return 0 }
        else if indexPath.row == 20 && (selectedLocal.nearInfo?.isEmpty)! { return 0 }
        else if indexPath.row == 21 && (selectedLocal.moreInfo?.isEmpty)! { return 0 }
        else { return UITableViewAutomaticDimension }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "localTitleCellID", for: indexPath) as! LocalTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.localTitleLabel.textColor = currentTheme.textColor
            cell.localSubtitleLabel.textColor = currentTheme.textColor
            cell.localTitleLabel.text = selectedLocal.title
            cell.localSubtitleLabel.text = selectedLocal.subtitle
            return cell
            
        case 1:
            
            localTimeCell = tableView.dequeueReusableCell(withIdentifier: "localDataCellID", for: indexPath) as! LocalTimeCell
            localTimeCell.selectionStyle = .none
            localTimeCell.backgroundColor = .clear
            localTimeCell.background_view.layer.cornerRadius = localTimeCell.background_view.frame.width / 32
            localTimeCell.background_view.backgroundColor = currentTheme.backgroundColor
            localTimeCell.dayTimeTitleLabel.textColor = currentTheme.textColor
            localTimeCell.openClosedLabel.textColor = currentTheme.textColor
            localTimeCell.showTimetableButtonOutlet.setImage(#imageLiteral(resourceName: "arrow1").withRenderingMode(.alwaysTemplate), for: .normal)
            localTimeCell.showTimetableButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 10)
            localTimeCell.showTimetableButtonOutlet.tintColor = currentTheme.separatorColor
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let currentDay = formatter.string(from: Date())
            
            localTimeCell.dayTimeTitleLabel.text = currentDay
            localTimeCell.openClosedLabel.text = Time.getTimetable(timetable: selectedLocal.timetable)
            
            return localTimeCell
            
        case 2:
            
            localDaysWeekCell = tableView.dequeueReusableCell(withIdentifier: "daysWeekCellID", for: indexPath) as! LocalDaysWeekCell
            localDaysWeekCell.selectionStyle = .none
            localDaysWeekCell.backgroundColor = .clear
            localDaysWeekCell.background_view.layer.cornerRadius = localDaysWeekCell.background_view.frame.width / 32
            localDaysWeekCell.background_view.backgroundColor = currentTheme.backgroundColor
            
            let dayLabels = [localDaysWeekCell.mondayTimetableLabel,localDaysWeekCell.thuesdayTimetableLabel,localDaysWeekCell.wednesdayTimetableLabel,localDaysWeekCell.thursdayTimetableLabel,localDaysWeekCell.fridayTimetableLabel,localDaysWeekCell.saturdayTimetableLabel,localDaysWeekCell.sundayTimetableLabel]
            
            localDaysWeekCell.mondayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.thuesdayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.wednsdayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.thursdayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.fridayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.saturdayTitleLabel.textColor = currentTheme.textColor
            localDaysWeekCell.sundayTitleLabel.textColor = currentTheme.textColor
            
            localDaysWeekCell.mondayTitleLabel.text = User.language.w1
            localDaysWeekCell.thuesdayTitleLabel.text = User.language.w2
            localDaysWeekCell.wednsdayTitleLabel.text = User.language.w3
            localDaysWeekCell.thursdayTitleLabel.text = User.language.w4
            localDaysWeekCell.fridayTitleLabel.text = User.language.w5
            localDaysWeekCell.saturdayTitleLabel.text = User.language.w6
            localDaysWeekCell.sundayTitleLabel.text = User.language.w7
            
            var timetableIndex = Int()
            
            for i in 0..<dayLabels.count {
                dayLabels[i]?.textColor = currentTheme.textColor
                
                if selectedLocal.timetable[2 * i] != "Close" {
                    dayLabels[i]?.text = selectedLocal.timetable[timetableIndex]
                    timetableIndex += 1
                    dayLabels[i]?.text?.append(" - \(selectedLocal.timetable[timetableIndex])")
                    timetableIndex += 1
                } else {
                    dayLabels[i]?.text = User.language.close
                    timetableIndex += 2
                }
            }
            return localDaysWeekCell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "localPositionCellID", for: indexPath) as! LocalPositionCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.placeTitleLabel.textColor = currentTheme.textColor
            cell.addressLabel.textColor = currentTheme.textColor
            cell.placeTitleLabel.text = selectedLocal.city
            cell.addressLabel.text = selectedLocal.address
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateTitleCellID", for: indexPath) as! LocalRatingViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.numberOfReviewsLabel.textColor = currentTheme.textColor
            cell.localRateBar.emptyImage = #imageLiteral(resourceName: "emptyStar")
            cell.localRateBar.fullImage = #imageLiteral(resourceName: "fullyStar")
            cell.localRateBar.tintColor = currentTheme.separatorColor
            cell.localRateBar.rating = selectedLocal.rating
            cell.numberOfReviewsLabel.text = String(selectedLocal.numberOfReviews) + " " + User.language.reviews
            return cell
            
        case 5:
            
            localLikeFavShareCell = tableView.dequeueReusableCell(withIdentifier: "likeFavSharesCellID", for: indexPath) as! LocalLikeFavShareCell
            localLikeFavShareCell.selectionStyle = .none
            localLikeFavShareCell.backgroundColor = .clear
            localLikeFavShareCell.background_view_1.layer.cornerRadius = localLikeFavShareCell.frame.width / 32
            localLikeFavShareCell.background_view_2.layer.cornerRadius = localLikeFavShareCell.frame.width / 32
            localLikeFavShareCell.background_view_1.backgroundColor = currentTheme.backgroundColor
            localLikeFavShareCell.background_view_2.backgroundColor = currentTheme.backgroundColor
            localLikeFavShareCell.numberOfLikeLabel.textColor = currentTheme.textColor
            localLikeFavShareCell.numberOfLikeLabel.text = String(likes)

            Database.checkFavLocal(user_email: User.email, local_id: selectedLocal.id!) { (isFavourite) in
                DispatchQueue.main.async {
                    self.isLocalAddedToFavourites = isFavourite

                    if isFavourite {
                        self.localLikeFavShareCell.likeIcon.setImage(#imageLiteral(resourceName: "fullyHeart"), for: .normal)
                    } else {
                        self.localLikeFavShareCell.likeIcon.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
                    }
                }
            }
            
            return localLikeFavShareCell
            
        case 6:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTitleCellID", for: indexPath) as! LocalDetailsTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.detailsTitleLabel.textColor = currentTheme.textColor
            cell.detailsTitleLabel.text = User.language.details
            return cell
            
        case 7:
            
            localDetailsCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellID", for: indexPath) as! LocalDetailsCell
            localDetailsCell.selectionStyle = .none
            localDetailsCell.backgroundColor = .clear
            localDetailsCell.background_view.layer.cornerRadius = localDetailsCell.background_view.frame.width / 32
            localDetailsCell.background_view.backgroundColor = currentTheme.backgroundColor
            localDetailsCell.localDetailsContentLabel.textColor = currentTheme.textColor
            localDetailsCell.localDetailsContentLabel.text = selectedLocal.details
            localDetailsCell.showMoreButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(3, 4, 4, 3)
            return localDetailsCell
            
        case 8:

            let cell = tableView.dequeueReusableCell(withIdentifier: "localEventCellID", for: indexPath) as! LocalEventCell
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            let selectedBgCell = UIView()
            selectedBgCell.backgroundColor = .clear
            cell.selectedBackgroundView = selectedBgCell
            cell.titleLabel.textColor = currentTheme.textColor
            cell.titleLabel.text = User.language.event_list
            return cell
            
        case 9,10:
            
            let icons = [#imageLiteral(resourceName: "music2"),#imageLiteral(resourceName: "place1")]
            let titles = [selectedLocal.music,selectedLocal.place]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "localSpecificInfoCellID", for: indexPath) as! LocalSpecificInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLabel.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 9]
            cell.titleLabel.text = titles[indexPath.row - 9]
            return cell
            
        case 11:

            localSpecificInfoIconCell = tableView.dequeueReusableCell(withIdentifier: "localSpecificInfoIconCell", for: indexPath) as! LocalSpecificInfoIconCell
            localSpecificInfoIconCell.selectionStyle = .none
            localSpecificInfoIconCell.backgroundColor = .clear
            localSpecificInfoIconCell.background_view.layer.cornerRadius = localSpecificInfoIconCell.background_view.frame.width / 32
            localSpecificInfoIconCell.background_view.backgroundColor = currentTheme.backgroundColor
            self.addQuickInfo(array: selectedLocal.quickInfo)
            return localSpecificInfoIconCell
            
        case 12:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactTitleCellID", for: indexPath) as! LocalContactTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.contactTitleLabel.textColor = currentTheme.textColor
            cell.contactTitleLabel.text = User.language.contacts
            return cell
            
        case 13,14,15:
            
            let icons = [#imageLiteral(resourceName: "phone1"),#imageLiteral(resourceName: "webSite1"),#imageLiteral(resourceName: "email1")]
            let titles = [selectedLocal.phoneNumber,"Web site","Write email"]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactUsCellID", for: indexPath) as! LocalContactCell
            cell.selectionStyle = .default
            cell.backgroundColor = .clear
            cell.selectedBackgroundView = selectedCellColor
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLabel.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 13]
            cell.titleLabel.text = titles[indexPath.row - 13]
            return cell
            
        case 16:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionInfoTitleCellID", for: indexPath) as! LocalPositionInfoTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.positionInfoTitleLabel.textColor = currentTheme.textColor
            cell.positionInfoTitleLabel.text = User.language.place_info
            return cell
            
        case 17:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "positionInfoCellID", for: indexPath) as! LocalPositionInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            
            cell.getDirectionButtonOutlet.backgroundColor = currentTheme.separatorColor
            cell.getDirectionButtonOutlet.setTitleColor(currentTheme.backgroundColor, for: .normal)
            cell.getDirectionButtonOutlet.layer.cornerRadius = cell.getDirectionButtonOutlet.frame.width / 8
            cell.getDirectionButtonOutlet.setTitle(User.language.get_direction, for: .normal)
            
            cell.addressTitleLabel.textColor = currentTheme.textColor
            cell.addressTitleLabel.text = selectedLocal.address
            
            let legalMapLabel = cell.map.subviews[1]
            legalMapLabel.isHidden = true
            
            let address = selectedLocal.address
            UserDefaults.standard.set(address, forKey: "LOCAL_ADDRESS")
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
                cell.map.isUserInteractionEnabled = true
                
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                let marker = MKPointAnnotation()
                marker.coordinate = location.coordinate
                marker.title = "Apple"
                
                cell.map.addAnnotation(marker)
            }
            return cell
            
        case 18,19,20,21:
            
            let icons = [#imageLiteral(resourceName: "parking1"),#imageLiteral(resourceName: "bus1"),#imageLiteral(resourceName: "near1"),#imageLiteral(resourceName: "info")]
            let titles = [selectedLocal.parkingInfo,selectedLocal.ptInfo,selectedLocal.nearInfo,selectedLocal.moreInfo]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIDK", for: indexPath) as! LocalMoreInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.titleLabel.textColor = currentTheme.textColor
            cell.icon.image = icons[indexPath.row - 18]
            cell.titleLabel.text = titles[indexPath.row - 18]
            
            return cell
            
        case 22:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTitleCellID", for: indexPath) as! LocalReviewTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.reviewTitleLabel.textColor = currentTheme.textColor
            cell.reviewTitleLabel.text = User.language.reviews
            return cell
            
        case 23:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "writeReviewButtonCellID", for: indexPath) as! LocalWriteReviewCell
            cell.selectionStyle = .default
            cell.backgroundColor = .clear
            cell.background_view.layer.cornerRadius = cell.background_view.frame.width / 32
            cell.background_view.backgroundColor = currentTheme.backgroundColor
            cell.selectedBackgroundView = selectedCellColor
            cell.writeReviewTitleLabel.textColor = currentTheme.textColor
            cell.writeReviewTitleLabel.text = User.language.reviews
            return cell
            
        default:
            
            return UITableViewCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        self.downloadImages()
        
        Database.getLocalLikes(local_id: selectedLocal.id!) { (likes) in
            DispatchQueue.main.async {
                self.likes = likes
                self.tableView.reloadData()
            }
        }
        
        tableView.separatorColor = .clear
        
        backgroundImage = UIImageView(image: profileImage.image)
        backgroundImage.frame = tableView.frame
        backgroundImage.addBlurEffect(style: currentTheme.blurStyle)
        tableView.backgroundView = backgroundImage
        
        navigationController?.navigationBar.isTranslucent = true
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        selectedCellColor.layer.cornerRadius = view.frame.width / 32
        selectedCellColor.alpha = 0.0
        
        dropUpMenu.view.tintColor = .black
    }
}
