//
//  CreateLocalTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension CreateLocalTVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func presentAlbumCover() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = Image.resizeImage(image: image, targetSize: CGSize(width: 1000, height: 590))
        }
        self.dismiss(animated: true, completion: nil)
    }
}

class CreateLocalTVC: UITableViewController {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var headerView: UIImageView!
    
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var selectedLocal: Local?
    var coverImage: UIImage?
    var isEditingMode = Bool()
    
    var localLatitude = CLLocationDegrees()
    var localLongitude = CLLocationDegrees()
    
    var localJSON = String()
    
    var indexPathDequed = [IndexPath]()
    
    var editLocalTitleCell = EditLocalTitleCell()
    var editLocalTimetableCell = EditLocalTimetableCell()
    var editLocalAddressCell = EditLocalAddressCell()
    var editLocalCityCell = EditLocalCityCell()
    var editLocalDetailsTitleCell = EditLocalDetailsTitleCell()
    var editLocalAddDetailsCell = EditLocalAddDetailsCell()
    var editLocalMusicCell = EditLocalMusicCell()
    var editLocalPlaceCell = EditLocalPlaceCell()
    var editLocalQuickInfoCell = EditLocalQuickInfoCell()
    var editLocalPhoneCell = EditLocalPhoneCell()
    var editLocalWebSiteCell = EditLocalWebSiteCell()
    var editLocalEmailCell = EditLocalEmailCell()
    var editLocalPositionCell = EditLocalPositionCell()
    var editLocalParkingCell = EditLocalParkingCell()
    var editLocalPublicTransportCell = EditLocalPublicTransportCell()
    var editLocalNearCell = EditLocalNearCell()
    var editLocalInfoCell = EditLocalInfoCell()
    
    var details = String()
    var quikInfo = [Int]()
    var phone = String()
    var city = String()
    var timetable = [String]()
    var music = String()
    var place = String()
    var phoneNumber = String()
    var webSite = String()
    var localEmail = String()
    var parkingInfo = String()
    var ptInfo = String()
    var nearInfo = String()
    var moreInfo = String()
    
    var imagePicker = UIImagePickerController()
    var imageView = UIImageView()
    var doneButton = UIButton()
    var photosPicked = [UIImage]()
    
    var selectedCellBackgroundView = UIView()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAlbumCover))
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(tapGesture)
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(setCoordinateFromAddress), for: .touchUpInside)
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        if selectedLocal != nil {
            isEditingMode = true
        } else {
            isEditingMode = false
        }
        
        if let image = imageView.image {
            headerView.image = image
        }
    }
    
    func addErrorView(errorDescription: String) {
        navigationController?.view.addSubview(errorView)
        
        let errorViewHeight: CGFloat = 50
        errorView.frame = CGRect(x: 1, y: view.frame.size.height, width: view.frame.size.width - 2, height: errorViewHeight)
        errorView.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        errorView.layer.cornerRadius = errorView.frame.size.height / 8
        errorLabel.text = errorDescription
        
        UIView.animate(withDuration: 0.6, animations: {
            self.errorView.frame.origin.y = self.view.frame.size.height - errorViewHeight - 2
        })
        tableView.contentInset = UIEdgeInsetsMake(0, 0, errorViewHeight + 2, 0)
    }
    
    func removeErrorView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.errorView.frame.origin.y = self.view.frame.size.height
        })
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func generateUniqueValue() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        return "IMG\(components.year!)\(components.month!)\(components.day!)\(components.hour!)\(components.minute!)\(components.second!)\(components.nanosecond!)"
    }
    
    func uploadPhotos(photos:[UIImage], id: Int) {
        
        if photos.isEmpty { return }
        
        for i in 0..<photos.count {
            let imageView = UIImageView()
            imageView.image = Image.resizeImage(image: photos[i], targetSize: CGSize(width: 960, height: 540))
            let uploadURL = NSURL(string: PHP.DOMAIN + PHP.USER_IMG_SET)
            let parameters = ["folderID":User.email, "path":"userLocals/\(User.email)\(id)","imgID": self.generateUniqueValue(),"id": String(id)]
            Database.imageUploadRequest(imageView: imageView, uploadUrl: uploadURL!, parameters: parameters, imgName: parameters["imgID"]!, completion: {_ in})
        }
    }
    
    @objc func setCoordinateFromAddress() {
        
        view.endEditing(true)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let address = editLocalAddressCell.localAddressTF.text!
        var myLocation = CLLocationCoordinate2D()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                self.addErrorView(errorDescription: User.language.invalid_address)
                return
            }
            self.removeErrorView()
            
            myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            self.localLatitude = myLocation.latitude
            self.localLongitude = myLocation.longitude
            
            geoCoder.reverseGeocodeLocation((placemarks.first?.location)!, completionHandler: {placemarks,error in
                self.requestUpload(latitude: Double(myLocation.latitude), longitude: Double(myLocation.longitude))
            })
        }
    }
    
    func requestUpload(latitude: Double, longitude: Double) {
        
        let titleText = editLocalTitleCell.localTitleTF.text?.trimmingCharacters(in: .whitespaces)
        let subtitleText = editLocalTitleCell.localSubtitleTF.text?.trimmingCharacters(in: .whitespaces)
        if let phoneNumberTF = editLocalPhoneCell.phoneTF { phoneNumber = phoneNumberTF.text! } else { phoneNumber = (selectedLocal?.phoneNumber)! }
        let cityText = editLocalCityCell.cityTF.text?.trimmingCharacters(in: .whitespaces)
        if let timetable = UserDefaults.standard.value(forKey: "LOCAL_TIMETABLE") as? [String] { self.timetable = timetable }
        if let details = selectedLocal?.details {
            self.details = details
        }
        if let details = UserDefaults.standard.value(forKey: "LOCAL_DETAILS") as? String {
            self.details = details
        }
        
        if let quickInfo = selectedLocal?.quickInfo {
            self.quikInfo = quickInfo
        }
        if let quikInfo = UserDefaults.standard.value(forKey: "QUICK_INFO") as? [Int] {
            self.quikInfo = quikInfo
        }
        
        if (titleText?.isEmpty)! || (subtitleText?.isEmpty)! {
            self.addErrorView(errorDescription: User.language.local_error_1)
        } else if (cityText?.isEmpty)! {
            self.addErrorView(errorDescription: User.language.local_error_2)
        } else if phoneNumber.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_3)
        } else if !phoneNumber.isPhoneNumber {
            self.addErrorView(errorDescription: User.language.local_error_4)
        } else if details.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_5)
        } else if timetable.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_6)
        } else if imageView.image == nil {
            self.addErrorView(errorDescription: User.language.local_error_7)
        } else if quikInfo.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_8)
        } else {

            let json = self.setupJSON()
            
            if isEditingMode {
                if let id = selectedLocal?.id {
                    Database.updateLocal(latitude: latitude, longitude: longitude, owner: User.email, id: id, json: json)
                    self.uploadPhotos(photos: LocalPhotosCVC.images, id: id)
                    self.uploadCoverImg(id: id, imageView: imageView)
                }
            } else {
                Database.uploadLocal(latitude: latitude, longitude: longitude, owner: User.email, json: json) { (id) in
                    self.uploadPhotos(photos: LocalPhotosCVC.images, id: id)
                    self.uploadCoverImg(id: id, imageView: self.imageView)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadCoverImg(id: Int, imageView: UIImageView) {
        let url = URL(string: PHP.DOMAIN + PHP.USER_IMG_SET)
        let parameters = ["folderID":User.email,"path":"/userLocals/\(User.email)\(id)"]
        Database.imageUploadRequest(imageView: imageView, uploadUrl: url! as NSURL, parameters: parameters, imgName: "coverImg", completion: {_ in})
    }
    
    func setupJSON() -> String {
        
        if let musicTF = editLocalMusicCell.musicTF {music = musicTF.text!}
        if let placeTF = editLocalPlaceCell.placeTF {place = placeTF.text!}
        if let webSiteTF = editLocalWebSiteCell.webSiteTF {webSite = webSiteTF.text!}
        if let emailTF = editLocalEmailCell.emailTF {localEmail = emailTF.text!}
        if let parkingInfoTF = editLocalParkingCell.parkingTF {parkingInfo = parkingInfoTF.text!}
        if let ptInfoTF = editLocalPublicTransportCell.publicTransportTF {ptInfo = ptInfoTF.text!}
        if let nearInfoTF = editLocalNearCell.nearTF {nearInfo = nearInfoTF.text!}
        if let moreInfoTF = editLocalInfoCell.infoTF {moreInfo = moreInfoTF.text!}
        
        let title = editLocalTitleCell.localTitleTF.text!
        let subtitle = editLocalTitleCell.localSubtitleTF.text!
        let address = editLocalAddressCell.localAddressTF.text!
        let city = editLocalCityCell.cityTF.text!
        
        if let phoneNumberTF = editLocalPhoneCell.phoneTF { phoneNumber = phoneNumberTF.text! } else { phoneNumber = (selectedLocal?.phoneNumber)! }
        
        let local = Local(id: nil, city: city, title: title, subtitle: subtitle, timetable: timetable, address: address, details: details, music: music, place: place, quickInfo: quikInfo, phoneNumber: phoneNumber, webSite: webSite, email: localEmail,likes: 0, parkingInfo: parkingInfo, ptInfo: ptInfo, nearInfo: nearInfo, moreInfo: moreInfo ,rating: 0, owner: User.email, numberOfReviews: 0)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(local)
        let json = String(data: data, encoding: .utf8)!
        
        return json
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func presentPhotosCVC() {
        let mainStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        let viewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "photosCVCID") as UIViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalWriteDetailsVC {
            destination.details = details
        }
        if let destination = segue.destination as? LocalPhotosCVC,
            let selectedLocal = selectedLocal {
            destination.selectedLocal = selectedLocal
        }
        if let destination = segue.destination as? LocalQuickInfoVC {
            if let selectedLocal = selectedLocal {
                destination.itemsSelected = selectedLocal.quickInfo
            }
            if let itemsSelected = UserDefaults.standard.value(forKey: "QUICK_INFO") as? [Int] {
                destination.itemsSelected = itemsSelected
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "editLocalPhotosID", for: indexPath) as! EditLocalPhotoAlbumCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.albumLabel.textColor = currentTheme.textColor
            cell.albumLabel.text = "+" + User.language.photos_album
            return cell
            
        case 1:
            
            editLocalTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! EditLocalTitleCell
            editLocalTitleCell.selectionStyle = .none
            editLocalTitleCell.backgroundColor = currentTheme.backgroundColor
            editLocalTitleCell.localTitleTF.attributedPlaceholder = NSAttributedString(string: User.language.title, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalTitleCell.localSubtitleTF.attributedPlaceholder = NSAttributedString(string: User.language.subtitle, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalTitleCell.localTitleTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalTitleCell.localSubtitleTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalTitleCell.localTitleTF.textColor = currentTheme.textColor
            editLocalTitleCell.localSubtitleTF.textColor = currentTheme.textColor
        
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalTitleCell.localTitleTF.text = selectedLocal?.title
                editLocalTitleCell.localSubtitleTF.text = selectedLocal?.subtitle
            }
            
            return editLocalTitleCell
            
        case 2:
            
            editLocalTimetableCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! EditLocalTimetableCell
            editLocalTimetableCell.selectionStyle = .default
            editLocalTimetableCell.backgroundColor = currentTheme.backgroundColor
            editLocalTimetableCell.selectedBackgroundView = selectedCellBackgroundView
            editLocalTimetableCell.localTimetableTitleLabel.textColor = currentTheme.textColor
            editLocalTimetableCell.localTimetableTitleLabel.text = User.language.local_timetable
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                if let timetable = selectedLocal?.timetable {
                    UserDefaults.standard.set(timetable, forKey: "LOCAL_TIMETABLE")
                } else {
                    UserDefaults.standard.set([], forKey: "LOCAL_TIMETABLE")
                }
            }
            
            return editLocalTimetableCell
            
        case 3:
            
            editLocalAddressCell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! EditLocalAddressCell
            editLocalAddressCell.selectionStyle = .none
            editLocalAddressCell.backgroundColor = currentTheme.backgroundColor
            editLocalAddressCell.localAddressTF.attributedPlaceholder = NSAttributedString(string: User.language.address, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalAddressCell.localAddressTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalAddressCell.localAddressTF.textColor = currentTheme.textColor
        
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalAddressCell.localAddressTF.text = selectedLocal?.address
            }
            
            return editLocalAddressCell
            
        case 4:
            
            editLocalCityCell = tableView.dequeueReusableCell(withIdentifier: "cell3City", for: indexPath) as! EditLocalCityCell
            editLocalCityCell.selectionStyle = .none
            editLocalCityCell.backgroundColor = currentTheme.backgroundColor
            editLocalCityCell.cityTF.textColor = currentTheme.textColor
            editLocalCityCell.cityTF.attributedPlaceholder = NSAttributedString(string: User.language.city, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalCityCell.cityTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalCityCell.cityTF.textColor = currentTheme.textColor
           
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalCityCell.cityTF.text = selectedLocal?.city
            }
            
            return editLocalCityCell
            
        case 5:
            
            editLocalDetailsTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! EditLocalDetailsTitleCell
            editLocalDetailsTitleCell.selectionStyle = .default
            editLocalDetailsTitleCell.backgroundColor = currentTheme.backgroundColor
            editLocalDetailsTitleCell.selectedBackgroundView = selectedCellBackgroundView
            editLocalDetailsTitleCell.detailsTitleLabel.textColor = currentTheme.textColor
            editLocalDetailsTitleCell.detailsTitleLabel.text = User.language.details
            return editLocalDetailsTitleCell
            
        case 6:
            
            editLocalAddDetailsCell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! EditLocalAddDetailsCell
            editLocalAddDetailsCell.selectionStyle = .default
            editLocalAddDetailsCell.backgroundColor = currentTheme.backgroundColor
            editLocalAddDetailsCell.selectedBackgroundView = selectedCellBackgroundView
            editLocalAddDetailsCell.addDetailsContentLabel.text = selectedLocal?.details
            editLocalAddDetailsCell.addDetailsTitleLabel.text = User.language.add_details
            editLocalAddDetailsCell.addDetailsContentLabel.textColor = currentTheme.textColor
            editLocalAddDetailsCell.addDetailsTitleLabel.textColor = currentTheme.textColor

            if let details = UserDefaults.standard.value(forKey: "LOCAL_DETAILS") as? String {
                editLocalAddDetailsCell.addDetailsContentLabel.text = details
            } else {
                editLocalAddDetailsCell.addDetailsContentLabel.text = selectedLocal?.details
            }
            
            return editLocalAddDetailsCell
            
        case 7:
            
            editLocalMusicCell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! EditLocalMusicCell
            editLocalMusicCell.selectionStyle = .none
            editLocalMusicCell.backgroundColor = currentTheme.backgroundColor
            editLocalMusicCell.musicTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalMusicCell.musicTF.textColor = currentTheme.textColor
            editLocalMusicCell.musicTF.attributedPlaceholder = NSAttributedString(string: User.language.music, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalMusicCell.musicTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalMusicCell.musicTF.text = selectedLocal?.music
            }
            
            return editLocalMusicCell
            
        case 8:
            
            editLocalPlaceCell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! EditLocalPlaceCell
            editLocalPlaceCell.selectionStyle = .none
            editLocalPlaceCell.backgroundColor = currentTheme.backgroundColor
            editLocalPlaceCell.placeTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalPlaceCell.placeTF.textColor = currentTheme.textColor
            editLocalPlaceCell.placeTF.attributedPlaceholder = NSAttributedString(string: User.language.place, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalPlaceCell.placeTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalPlaceCell.placeTF.text = selectedLocal?.place
            }
            
            return editLocalPlaceCell
            
        case 9:
            
            editLocalQuickInfoCell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! EditLocalQuickInfoCell
            editLocalQuickInfoCell.selectionStyle = .default
            editLocalQuickInfoCell.backgroundColor = currentTheme.backgroundColor
            editLocalQuickInfoCell.selectedBackgroundView = selectedCellBackgroundView
            editLocalQuickInfoCell.quickInfoLabel.text = User.language.quick_info
            editLocalQuickInfoCell.quickInfoLabel.textColor = currentTheme.textColor
            
            if let quickInfo = selectedLocal?.quickInfo {
                UserDefaults.standard.set(quickInfo,forKey: "QUICK_INFOS")
            }
            
            return editLocalQuickInfoCell
            
        case 10:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! EditLocalContactTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contactTitleLabel.textColor = currentTheme.textColor
            cell.contactTitleLabel.text = User.language.contacts
            return cell
            
        case 11:
            
            editLocalPhoneCell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! EditLocalPhoneCell
            editLocalPhoneCell.selectionStyle = .none
            editLocalPhoneCell.backgroundColor = currentTheme.backgroundColor
            editLocalPhoneCell.phoneTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalPhoneCell.phoneTF.textColor = currentTheme.textColor
            editLocalPhoneCell.phoneTF.attributedPlaceholder = NSAttributedString(string: User.language.phone, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalPhoneCell.phoneTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalPhoneCell.phoneTF.text = selectedLocal?.phoneNumber
            }
            
            return editLocalPhoneCell
            
        case 12:
            
            editLocalWebSiteCell = tableView.dequeueReusableCell(withIdentifier: "cell11", for: indexPath) as! EditLocalWebSiteCell
            editLocalWebSiteCell.selectionStyle = .none
            editLocalWebSiteCell.backgroundColor = currentTheme.backgroundColor
            editLocalWebSiteCell.webSiteTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalWebSiteCell.webSiteTF.textColor = currentTheme.textColor
            editLocalWebSiteCell.webSiteTF.attributedPlaceholder = NSAttributedString(string: User.language.web_site_link, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalWebSiteCell.webSiteTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalWebSiteCell.webSiteTF.text = selectedLocal?.webSite
            }
            
            return editLocalWebSiteCell
            
        case 13:
            
            editLocalEmailCell = tableView.dequeueReusableCell(withIdentifier: "cell12", for: indexPath) as! EditLocalEmailCell
            editLocalEmailCell.selectionStyle = .none
            editLocalEmailCell.backgroundColor = currentTheme.backgroundColor
            editLocalEmailCell.emailTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalEmailCell.emailTF.textColor = currentTheme.textColor
            editLocalEmailCell.emailTF.attributedPlaceholder = NSAttributedString(string: User.language.email, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalEmailCell.emailTF.textColor = currentTheme.textColor

            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalEmailCell.emailTF.text = selectedLocal?.email
            }

            return editLocalEmailCell
            
        case 14:
            
            editLocalPositionCell = tableView.dequeueReusableCell(withIdentifier: "cell13", for: indexPath) as! EditLocalPositionCell
            editLocalPositionCell.selectionStyle = .none
            editLocalPositionCell.backgroundColor = currentTheme.backgroundColor
            editLocalPositionCell.positionTitleLabel.textColor = currentTheme.textColor
            editLocalPositionCell.positionTitleLabel.text = User.language.place_info
            return editLocalPositionCell
            
        case 15:
            
            editLocalParkingCell = tableView.dequeueReusableCell(withIdentifier: "cell14", for: indexPath) as! EditLocalParkingCell
            editLocalParkingCell.selectionStyle = .none
            editLocalParkingCell.backgroundColor = currentTheme.backgroundColor
            editLocalParkingCell.parkingTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalParkingCell.parkingTF.textColor = currentTheme.textColor
            editLocalParkingCell.parkingTF.attributedPlaceholder = NSAttributedString(string: User.language.parking, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalParkingCell.parkingTF.textColor = currentTheme.textColor
        
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalParkingCell.parkingTF.text = selectedLocal?.parkingInfo
            }
            
            return editLocalParkingCell
            
        case 16:
            
            editLocalPublicTransportCell = tableView.dequeueReusableCell(withIdentifier: "cell15", for: indexPath) as! EditLocalPublicTransportCell
            editLocalPublicTransportCell.selectionStyle = .none
            editLocalPublicTransportCell.backgroundColor = currentTheme.backgroundColor
            editLocalPublicTransportCell.publicTransportTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalPublicTransportCell.publicTransportTF.textColor = currentTheme.textColor
            editLocalPublicTransportCell.publicTransportTF.attributedPlaceholder = NSAttributedString(string: User.language.ptTransport, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalPublicTransportCell.publicTransportTF.textColor = currentTheme.textColor
        
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalPublicTransportCell.publicTransportTF.text = selectedLocal?.ptInfo
            }
            
            return editLocalPublicTransportCell
            
        case 17:
            
            editLocalNearCell = tableView.dequeueReusableCell(withIdentifier: "cell16", for: indexPath) as! EditLocalNearCell
            editLocalNearCell.selectionStyle = .none
            editLocalNearCell.backgroundColor = currentTheme.backgroundColor
            editLocalNearCell.nearTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalNearCell.nearTF.textColor = currentTheme.textColor
            editLocalNearCell.nearTF.attributedPlaceholder = NSAttributedString(string: User.language.near, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalNearCell.nearTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalNearCell.nearTF.text = selectedLocal?.nearInfo
            }
            
            return editLocalNearCell
            
        case 18:
            
            editLocalInfoCell = tableView.dequeueReusableCell(withIdentifier: "cell17", for: indexPath) as! EditLocalInfoCell
            editLocalInfoCell.selectionStyle = .none
            editLocalInfoCell.backgroundColor = currentTheme.backgroundColor
            editLocalInfoCell.infoTF.keyboardAppearance = currentTheme.keyboardLook
            editLocalInfoCell.infoTF.textColor = currentTheme.textColor
            editLocalInfoCell.infoTF.attributedPlaceholder = NSAttributedString(string: User.language.more_info, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editLocalInfoCell.infoTF.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editLocalInfoCell.infoTF.text = selectedLocal?.moreInfo
            }
            
            return editLocalInfoCell
            
        default: return UITableViewCell()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        errorView.removeFromSuperview()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 40, 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: "LOCAL_DETAILS")
        UserDefaults.standard.set(nil, forKey: "QUICK_INFO")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        selectedCellBackgroundView.backgroundColor = currentTheme.selectedColor
        navigationItem.title = User.language.create_new_local
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        imagePicker.navigationBar.barStyle = .black
        imagePicker.navigationBar.barTintColor = currentTheme.barColor
        imagePicker.navigationItem.rightBarButtonItem?.tintColor = currentTheme.textColor
        
        if imageView.image != nil {
            headerView.image = imageView.image
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let details = UserDefaults.standard.value(forKey: "LOCAL_DETAILS") as? String {
            self.details = details
        } else if let selectedLocal = selectedLocal {
            details = selectedLocal.details
        }
    }
}
