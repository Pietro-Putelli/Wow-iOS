//
//  CreateEventTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 13/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import MapKit

extension CreateEventTVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func presentAlbum() {
        
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

class CreateEventTVC: UITableViewController {
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var headerViewBackgroundImg: UIImageView!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var coveImgPlaceholder = UIImage()
    
    var activityIndicator: NVActivityIndicatorView! = nil
    var backgroundLoadView = UIView()
    
    var imagePicker = UIImagePickerController()
    var imageView = UIImageView()
    
    var selectedCellColor = UIView()
    var doneButton = UIButton()
    
    var isEditingMode = Bool()
    
    var eventLatitude = Double()
    var eventLongitude = Double()
    var localObjects = [LocalObject]()
    
    var indexPathDequed = [IndexPath]()

    var editEventTitleCell = EditEventTitleCell()
    var editEventDateTimeCell = EditEventDateTimeCell()
    var editEventPlaceCell = EditEventPlaceCell()
    var editEventAddressCell = EditEventAddressCell()
    var editEventCityCell = EditEventCityCell()
    var editEventAddDetailsCell =  EditEventAddDetailsCell()
    var editEventSetUpByCell = EditEventSetUpByCell()
    var editEventMusicCell = EditEventMusicCell()
    var editEventVipCell = EditEventVipCell()
    var editEventPriceCell = EditEventPriceCell()
    var editEventPhoneCell = EditEventPhoneCell()
    var editEventWebSiteCell = EditEventWebSiteCell()
    var editEventEmailCell = EditEventEmailCell()
    var editEventTicketCell = EditEventTicketCell()
    var editEventParkingCell = EditEventParkingCell()
    var editEventPublicTransportCell = EditEventPublicTransportCell()
    var editEventNearCell = EditEventNearCell()
    var editEventInfoCell = EditEventInfoCell()

    var dateTime = String()
    var details = String()
    var price = String()
    
    var music = String()
    var phone = String()
    var vip = String()
    
    var webSite = String()
    var email = String()
    var ticket = String()
    var setupby = String()
    
    var parking = String()
    var publicTransport = String()
    var near = String()
    var info = String()
    
    var fromDate = String()
    var toDate = String()
    var atDate = String()
    
    var localPickerView = UIPickerView()
    
    var keyboardHeight = CGFloat()
    
    var selectedLocal: LocalObject! = nil
    var selectedEvent: Event?
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(setCoordinateFromAddress), for: .touchUpInside)
        
        localPickerView.delegate = self
        localPickerView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAlbum))
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(tapGesture)
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 64
        
        if selectedEvent != nil {
            isEditingMode = true
        } else {
            isEditingMode = false
        }
        
        if let image = imageView.image {
            coverImageView.image = image
        }
    }
    
    func presentLoadView() {
        activityIndicator = NVActivityIndicatorView(frame: CGRect(origin: view.center, size: CGSize(width: 60, height: 60)), type: .ballRotateChase, color: currentTheme.textColor, padding: nil)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        backgroundLoadView.addSubview(activityIndicator)
        view.addSubview(backgroundLoadView)
    }
    
    func removeLoadView() {
        backgroundLoadView.removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    
    func addErrorView(errorDescription: String) {
        navigationController?.view.addSubview(errorView)
        
        let errorViewHeight: CGFloat = 50
        errorView.frame = CGRect(x: 1, y: view.frame.size.height, width: view.frame.size.width - 2, height: errorViewHeight)
        errorView.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        errorView.layer.cornerRadius = errorView.frame.size.height / 8
        errorLabel.text = errorDescription
        errorLabel.adjustsFontSizeToFitWidth = true
        
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
    
    @objc func setCoordinateFromAddress() {
        
        view.endEditing(true)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let address = editEventAddressCell.addressTitleTF.text!
        var myLocation = CLLocationCoordinate2D()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                if self.localObjects.isEmpty {
                    self.addErrorView(errorDescription: User.language.event_local_error)
                } else {
                    self.addErrorView(errorDescription: User.language.invalid_address)
                }
                return
            }
            self.removeErrorView()
            
            myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            self.eventLatitude = myLocation.latitude
            self.eventLongitude = myLocation.longitude
            
            geoCoder.reverseGeocodeLocation((placemarks.first?.location)!, completionHandler: {placemarks,error in
                self.requestUpload(latitude: myLocation.latitude, longitude: myLocation.longitude)
            })
        }
    }
    
    func requestUpload(latitude: Double, longitude: Double) {
        
        let titleText = self.editEventTitleCell.titleTF.text?.trimmingCharacters(in: .whitespaces)
        let cityText = self.editEventCityCell.cityTF.text?.trimmingCharacters(in: .whitespaces)
        
        if let phoneTF = editEventPhoneCell.phoneTF { phone = phoneTF.text! }
        else if let selectedEvent = selectedEvent {
            phone = selectedEvent.phone
        }
        
        if let setypbyTF = editEventSetUpByCell.setUpByTF { setupby = setypbyTF.text! } else { setupby = (selectedEvent?.setUpBy)! }
        if let details = UserDefaults.standard.value(forKey: "EVENT_DETAILS") as? String { self.details = details }
        if let details = selectedEvent?.details {
            self.details = details
        }
        
        if let fromDate = UserDefaults.standard.value(forKey: "FROM_DATE") as? String,
            let toDate = UserDefaults.standard.value(forKey: "TO_DATE") as? String,
            let atDate = UserDefaults.standard.value(forKey: "AT_TIME") as? String {
            
            self.fromDate = fromDate
            self.toDate = toDate
            self.atDate = atDate
        } else if let selectedEvent = selectedEvent {
            fromDate = selectedEvent.fromDate
            toDate = selectedEvent.toDate
            atDate = selectedEvent.atDate
        }
        
        if (titleText?.isEmpty)! {
            self.addErrorView(errorDescription: User.language.event_error_1)
        } else if (cityText?.isEmpty)! {
            self.addErrorView(errorDescription: User.language.local_error_2)
        } else if details.isEmpty {
            addErrorView(errorDescription: User.language.local_error_5)
        } else if phone.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_3)
        } else if !phone.isPhoneNumber {
            self.addErrorView(errorDescription: User.language.local_error_4)
        } else if setupby.isEmpty {
            self.addErrorView(errorDescription: User.language.event_error_2)
        } else if imageView.image == nil {
            self.addErrorView(errorDescription: User.language.local_error_7)
        } else if fromDate.isEmpty {
            self.addErrorView(errorDescription: User.language.local_error_6)
        } else {
            
            let json = self.setupJSON()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            if let date = dateFormatter.date(from: toDate) {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                toDate = dateFormatter.string(from: date)
            }
            
            if isEditingMode {
                if let id = selectedEvent?.id, let local_id = selectedEvent?.local_id {
                    Database.updateEvent(latitude: latitude, longitude: longitude, owner: User.email, id: id, local_id: local_id, to_date: toDate, json: json)
                    self.uploadCoverImg(id: id, imageView: self.imageView)
                }
            } else {
                Database.uploadEvent(latitude: latitude, longitude: longitude, owner: User.email, id: selectedLocal.id, to_date: toDate, json: json) { (id) in
                    DispatchQueue.main.async {
                        self.uploadCoverImg(id: id, imageView: self.imageView)
                        let message_content = Notifications.setForEvents(local_name: self.selectedLocal.title, event_name: self.editEventTitleCell.titleTF.text!)
                        Database.sendNewEventNotification(local_id: self.selectedLocal.id, event_id: id, message_content: message_content)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadCoverImg(id: Int, imageView: UIImageView) {
        let url = URL(string: PHP.DOMAIN + PHP.USER_IMG_SET)
        let parametes = ["folderID":User.email,"path":"userEvents/\(User.email)\(id)"]
        imageView.image = Image.resizeImage(image: imageView.image!, targetSize: CGSize(width: 960, height: 540))
        Database.imageUploadRequest(imageView: imageView, uploadUrl: url! as NSURL, parameters: parametes, imgName: "coverImg", completion: {(_) in})
    }
    
    func setupJSON() -> String {
        
        let title = editEventTitleCell.titleTF.text!
        let place = editEventPlaceCell.placeTitleTF.text
        let address = editEventAddressCell.addressTitleTF.text!
        let city = editEventCityCell.cityTF.text!
        
        if let musicTF = editEventMusicCell.musicTF { music = musicTF.text! } else { music = (selectedEvent?.music)! }
        if let priceTF = editEventPriceCell.priceTF {price = priceTF.text!}
        if let webSiteTF = editEventWebSiteCell.webSiteTF {webSite = webSiteTF.text!}
        if let emailTF = editEventEmailCell.emailTF {email = emailTF.text!}
        if let ticketTF = editEventTicketCell.ticketTF {ticket = ticketTF.text!}
        if let parkingTF = editEventParkingCell.parkingTF {parking = parkingTF.text!}
        if let ptInfoTF = editEventPublicTransportCell.publicTransportTF {publicTransport = ptInfoTF.text!}
        if let nearInfoTF = editEventNearCell.nearTF {near = nearInfoTF.text!}
        if let moreInfoTF = editEventInfoCell.infoTF {info = moreInfoTF.text!}
        
        var local_id = Int()
        if selectedLocal != nil {
            local_id = selectedLocal.id
        } else {
            local_id = (selectedEvent?.local_id)!
        }
        
        let event = Event(id: nil, local_id: local_id, owner: User.email, title: title, address: address, place: place, city: city, details: details, going: 0, likes: 0, fromDate: fromDate, toDate: toDate, atDate: atDate, setUpBy: setupby, music: music, vip: vip, price: price, phone: phone, webSite: webSite, email: email, ticket: ticket, parking: parking, publicTransport: publicTransport, near: near, info: info)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(event)
        let json = String(data: data, encoding: .utf8)!
        
        return json
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventWriteDetailsVC,
            let selectedEvent = selectedEvent {
            destination.details = selectedEvent.details
        }
        
        if let destination = segue.destination as? DateTimeVC,
            let selectedEvent = selectedEvent {
            destination.selectedEvent = selectedEvent
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 && localObjects.isEmpty {
            self.addErrorView(errorDescription: User.language.event_local_error)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {

        case 0:
            
            editEventTitleCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! EditEventTitleCell
            editEventTitleCell.selectionStyle = .none
            editEventTitleCell.backgroundColor = currentTheme.backgroundColor
            editEventTitleCell.titleTF.textColor = currentTheme.textColor
            editEventTitleCell.titleTF.attributedPlaceholder = NSAttributedString(string: User.language.title, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventTitleCell.titleTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventTitleCell.titleTF.text = selectedEvent?.title
            }
            
            return editEventTitleCell
            
        case 1:
            
            editEventDateTimeCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! EditEventDateTimeCell
            editEventDateTimeCell.selectionStyle = .default
            editEventDateTimeCell.selectedBackgroundView = selectedCellColor
            editEventDateTimeCell.backgroundColor = currentTheme.backgroundColor
            editEventDateTimeCell.dateTimeTitleLabel.textColor = currentTheme.textColor
            
            if !indexPathDequed.contains(indexPath) {
                if let selectedEvent = selectedEvent {
                    editEventDateTimeCell.dateTimeTitleLabel.text = "From \(selectedEvent.fromDate) to \(selectedEvent.toDate) at \(selectedEvent.atDate)"
                } else {
                    editEventDateTimeCell.dateTimeTitleLabel.text = User.language.date_time
                }
            }
            
            if let fromDate = UserDefaults.standard.value(forKey: "FROM_DATE") as? String,
                let toDate = UserDefaults.standard.value(forKey: "TO_DATE") as? String,
                let atDate = UserDefaults.standard.value(forKey: "AT_TIME") as? String {
                
                editEventDateTimeCell.dateTimeTitleLabel.text = "From \(fromDate) to \(toDate) at \(atDate)"
            }
            
            return editEventDateTimeCell
            
        case 2:
            
            editEventPlaceCell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! EditEventPlaceCell
            editEventPlaceCell.selectionStyle = .none
            editEventPlaceCell.backgroundColor = currentTheme.backgroundColor
            editEventPlaceCell.placeTitleTF.textColor = currentTheme.textColor
            editEventPlaceCell.placeTitleTF.attributedPlaceholder = NSAttributedString(string: User.language.place, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventPlaceCell.placeTitleTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventPlaceCell.placeTitleTF.text = selectedEvent?.place
            }
            
            return editEventPlaceCell
            
        case 3:

            editEventAddressCell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! EditEventAddressCell
            editEventAddressCell.selectionStyle = .none
            editEventAddressCell.backgroundColor = currentTheme.backgroundColor
            editEventAddressCell.addressTitleTF.textColor = currentTheme.textColor
            editEventAddressCell.addressTitleTF.attributedPlaceholder = NSAttributedString(string: User.language.address, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventAddressCell.addressTitleTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventAddressCell.addressTitleTF.text = selectedEvent?.address
            }
            
            return editEventAddressCell
            
        case 4:
            
            editEventCityCell = tableView.dequeueReusableCell(withIdentifier: "cell4city", for: indexPath) as! EditEventCityCell
            editEventCityCell.selectionStyle = .none
            editEventCityCell.backgroundColor = currentTheme.backgroundColor
            editEventCityCell.cityTF.textColor = currentTheme.textColor
            editEventCityCell.cityTF.attributedPlaceholder = NSAttributedString(string: User.language.city, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventCityCell.cityTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventCityCell.cityTF.text = selectedEvent?.city
            }
            
            return editEventCityCell

        case 5:
            
            editEventAddDetailsCell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! EditEventAddDetailsCell
            editEventAddDetailsCell.selectionStyle = .default
            editEventAddDetailsCell.selectedBackgroundView = selectedCellColor
            editEventAddDetailsCell.backgroundColor = currentTheme.backgroundColor
            editEventAddDetailsCell.addDetailsTitleLabel.textColor = currentTheme.textColor
            editEventAddDetailsCell.detailsContentLabel.textColor = currentTheme.textColor
            editEventAddDetailsCell.addDetailsTitleLabel.text = User.language.add_details
            
            if let details = UserDefaults.standard.value(forKey: "EVENT_DETAILS") as? String {
                editEventAddDetailsCell.detailsContentLabel.text = details
            } else {
                editEventAddDetailsCell.detailsContentLabel.text = selectedEvent?.details
            }
            
            return editEventAddDetailsCell
            
        case 6:
            
            editEventSetUpByCell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! EditEventSetUpByCell
            editEventSetUpByCell.selectionStyle = .none
            editEventSetUpByCell.backgroundColor = currentTheme.backgroundColor
            editEventSetUpByCell.setUpByTF.textColor = currentTheme.textColor
            editEventSetUpByCell.setUpByTF.attributedPlaceholder = NSAttributedString(string: User.language.set_up, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventSetUpByCell.setUpByTF.inputView = localPickerView
            editEventSetUpByCell.setUpByTF.inputView?.backgroundColor = currentTheme.backgroundColor
            editEventSetUpByCell.setUpByTF.isEnabled = true
            editEventSetUpByCell.setUpByTF.text = ""
            editEventSetUpByCell.setUpByTF.inputView = localPickerView
            localPickerView.reloadAllComponents()
            
            if localObjects.isEmpty {
                editEventSetUpByCell.setUpByTF.isUserInteractionEnabled = false
            } else {
                editEventSetUpByCell.setUpByTF.isUserInteractionEnabled = true
            }
            
            if let selectedEvent = selectedEvent {
                editEventSetUpByCell.setUpByTF.text = selectedEvent.setUpBy
                
                for index in 0..<localObjects.count {
                    if selectedEvent.id == localObjects[index].id {
                        localPickerView.selectedRow(inComponent: index)
                    }
                }
            }
            
            return editEventSetUpByCell
            
        case 7:
            
            editEventMusicCell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! EditEventMusicCell
            editEventMusicCell.selectionStyle = .none
            editEventMusicCell.backgroundColor = currentTheme.backgroundColor
            editEventMusicCell.musicTF.textColor = currentTheme.textColor
            editEventMusicCell.musicTF.attributedPlaceholder = NSAttributedString(string: User.language.music, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventMusicCell.musicTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventMusicCell.musicTF.text = selectedEvent?.music
            }
            
            return editEventMusicCell
            
        case 8:
            
            editEventVipCell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! EditEventVipCell
            editEventVipCell.selectionStyle = .none
            editEventVipCell.backgroundColor = currentTheme.backgroundColor
            editEventVipCell.vipTF.textColor = currentTheme.textColor
            editEventVipCell.vipTF.attributedPlaceholder = NSAttributedString(string: User.language.vip, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventVipCell.vipTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventVipCell.vipTF.text = selectedEvent?.vip
            }
            
            return editEventVipCell
            
        case 9:
            
            editEventPriceCell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! EditEventPriceCell
            editEventPriceCell.selectionStyle = .none
            editEventPriceCell.backgroundColor = currentTheme.backgroundColor
            editEventPriceCell.priceTF.textColor = currentTheme.textColor
            editEventPriceCell.priceTF.attributedPlaceholder = NSAttributedString(string: User.language.price, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventPriceCell.priceTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventPriceCell.priceTF.text = selectedEvent?.price
            }
            
            return editEventPriceCell
            
        case 10:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell11", for: indexPath) as! EditEventContactTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.contactTitleLabel.textColor = currentTheme.textColor
            cell.contactTitleLabel.text = User.language.contacts
            return cell
            
        case 11:
            
            editEventPhoneCell = tableView.dequeueReusableCell(withIdentifier: "cell12", for: indexPath) as! EditEventPhoneCell
            editEventPhoneCell.selectionStyle = .none
            editEventPhoneCell.backgroundColor = currentTheme.backgroundColor
            editEventPhoneCell.phoneTF.textColor = currentTheme.textColor
            editEventPhoneCell.phoneTF.attributedPlaceholder = NSAttributedString(string: User.language.phone, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventPhoneCell.phoneTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventPhoneCell.phoneTF.text = selectedEvent?.phone
            }
            
            return editEventPhoneCell
            
        case 12:
            
            editEventWebSiteCell = tableView.dequeueReusableCell(withIdentifier: "cell13", for: indexPath) as! EditEventWebSiteCell
            editEventWebSiteCell.selectionStyle = .none
            editEventWebSiteCell.backgroundColor = currentTheme.backgroundColor
            editEventWebSiteCell.webSiteTF.textColor = currentTheme.textColor
            editEventWebSiteCell.webSiteTF.attributedPlaceholder = NSAttributedString(string: User.language.web_site_link, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventWebSiteCell.webSiteTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventWebSiteCell.webSiteTF.text = selectedEvent?.webSite
            }
            
            return editEventWebSiteCell
            
        case 13:
            
            editEventEmailCell = tableView.dequeueReusableCell(withIdentifier: "cell14", for: indexPath) as! EditEventEmailCell
            editEventEmailCell.selectionStyle = .none
            editEventEmailCell.backgroundColor = currentTheme.backgroundColor
            editEventEmailCell.emailTF.textColor = currentTheme.textColor
            editEventEmailCell.emailTF.attributedPlaceholder = NSAttributedString(string: User.language.email, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventEmailCell.emailTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventEmailCell.emailTF.text = selectedEvent?.email
            }
            
            return editEventEmailCell
            
        case 14:
            
            editEventTicketCell = tableView.dequeueReusableCell(withIdentifier: "cell15", for: indexPath) as! EditEventTicketCell
            editEventTicketCell.selectionStyle = .none
            editEventTicketCell.backgroundColor = currentTheme.backgroundColor
            editEventTicketCell.ticketTF.textColor = currentTheme.textColor
            editEventTicketCell.ticketTF.attributedPlaceholder = NSAttributedString(string: User.language.tickets, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventTicketCell.ticketTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventTicketCell.ticketTF.text = selectedEvent?.ticket
            }
            
            return editEventTicketCell
            
        case 15:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell17", for: indexPath) as! EditEventPositionTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = currentTheme.backgroundColor
            cell.positionInfoTitleLabel.textColor = currentTheme.textColor
            cell.positionInfoTitleLabel.text = User.language.place_info
            return cell
            
        case 16:
            
            editEventParkingCell = tableView.dequeueReusableCell(withIdentifier: "cell18", for: indexPath) as! EditEventParkingCell
            editEventParkingCell.selectionStyle = .none
            editEventParkingCell.backgroundColor = currentTheme.backgroundColor
            editEventParkingCell.parkingTF.textColor = currentTheme.textColor
            editEventParkingCell.parkingTF.attributedPlaceholder = NSAttributedString(string: User.language.parking, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventParkingCell.parkingTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventParkingCell.parkingTF.text = selectedEvent?.parking
            }
            
            return editEventParkingCell
        
        case 17:
            
            editEventPublicTransportCell = tableView.dequeueReusableCell(withIdentifier: "cell19", for: indexPath) as! EditEventPublicTransportCell
            editEventPublicTransportCell.selectionStyle = .none
            editEventPublicTransportCell.backgroundColor = currentTheme.backgroundColor
            editEventPublicTransportCell.publicTransportTF.textColor = currentTheme.textColor
            editEventPublicTransportCell.publicTransportTF.attributedPlaceholder = NSAttributedString(string: User.language.ptTransport, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventPublicTransportCell.publicTransportTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventPublicTransportCell.publicTransportTF.text = selectedEvent?.publicTransport
            }
            
            return editEventPublicTransportCell
            
        case 18:
            
            editEventNearCell = tableView.dequeueReusableCell(withIdentifier: "cell20", for: indexPath) as! EditEventNearCell
            editEventNearCell.selectionStyle = .none
            editEventNearCell.backgroundColor = currentTheme.backgroundColor
            editEventNearCell.nearTF.textColor = currentTheme.textColor
            editEventNearCell.nearTF.attributedPlaceholder = NSAttributedString(string: User.language.near, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventNearCell.nearTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventNearCell.nearTF.text = selectedEvent?.near
            }
            
            return editEventNearCell
            
        case 19:
            
            editEventInfoCell = tableView.dequeueReusableCell(withIdentifier: "cell21", for: indexPath) as! EditEventInfoCell
            editEventInfoCell.selectionStyle = .none
            editEventInfoCell.backgroundColor = currentTheme.backgroundColor
            editEventInfoCell.infoTF.textColor = currentTheme.textColor
            editEventInfoCell.infoTF.attributedPlaceholder = NSAttributedString(string: User.language.more_info, attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            editEventInfoCell.infoTF.keyboardAppearance = currentTheme.keyboardLook
            
            if !indexPathDequed.contains(indexPath) {
                indexPathDequed.append(indexPath)
                editEventInfoCell.infoTF.text = selectedEvent?.info
            }
            
            return editEventInfoCell
            
        default: return UITableViewCell()
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        errorView.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: "EVENT_DETAILS")
//        UserDefaults.standard.set(nil, forKey: "FROM_DATE")
//        UserDefaults.standard.set(nil, forKey: "TO_DATE")
//        UserDefaults.standard.set(nil, forKey: "AT_TIME")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        selectedCellColor.backgroundColor = currentTheme.selectedColor
        navigationItem.title = User.language.create_new_event
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        imagePicker.navigationBar.barStyle = .black
        imagePicker.navigationBar.barTintColor = currentTheme.barColor
        imagePicker.navigationItem.rightBarButtonItem?.tintColor = currentTheme.textColor
        
        let backgorundImg = [#imageLiteral(resourceName: "img_01"),#imageLiteral(resourceName: "img_02"),#imageLiteral(resourceName: "img_03"),#imageLiteral(resourceName: "img_04"),#imageLiteral(resourceName: "img_05"),#imageLiteral(resourceName: "img_06"),#imageLiteral(resourceName: "img_07")]
        let randIndex = Int(arc4random_uniform(UInt32(backgorundImg.count - 1)))
        headerViewBackgroundImg.image = backgorundImg[randIndex]
        
        backgroundLoadView.frame = UIScreen.main.bounds
        backgroundLoadView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if let image = imageView.image {
            coverImageView.image = image
        }
        
        Database.getLocals(user_email: User.email) { (locals) in
            DispatchQueue.main.async {
                self.localObjects = locals
                self.localPickerView.reloadAllComponents()
                self.tableView.reloadData()
                
                if locals.isEmpty {
                    self.addErrorView(errorDescription: User.language.event_local_error)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension CreateEventTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localObjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localObjects[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: localObjects[row].title, attributes: [NSAttributedStringKey.foregroundColor : currentTheme.textColor])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocal = localObjects[row]
        editEventSetUpByCell.setUpByTF.text = selectedLocal.title
    }
}

struct LocalObject {
    let id: Int
    let title: String
}





