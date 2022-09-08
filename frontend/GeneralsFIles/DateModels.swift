//
//  LocalsJSONData.swift
//  eventsProject
//
//  Created by Pietro Putelli on 27/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

class UploadJSONData: Codable {
    
    let latitudeFrom: Double
    let longitudeFrom: Double
    let maxDistance: Double
    
    init(latitudeFrom:Double, longitudeFrom:Double, maxDistance:Double) {
        self.latitudeFrom = latitudeFrom
        self.longitudeFrom = longitudeFrom
        self.maxDistance = maxDistance
    }
}

class Image {
    
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func setImage(image: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        UserDefaults.standard.set(imageData, forKey: USER_KEYS.PROFILE_PICTURE)
    }
    
    class func cleanMemory() {
        UserDefaults.standard.set(nil, forKey: USER_KEYS.PROFILE_PICTURE)
    }
}

struct STORYBOARD {
    static let empty_alert_id = "EmptyAlertView"
    static let slider_view_id = "SliderView"
    static let empty_alert_home_id = "EmptyAlertViewHome"
}

class SliderView: UIView {
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var slider: CustomSlider!
}

class EmptyAlertViewHome: UIView {
    
    @IBOutlet weak var alertLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 60)
        self.layer.cornerRadius = self.frame.height / 4
        
        alertLabel.center = self.center
        alertLabel.adjustsFontSizeToFitWidth = true
    }
    
    func removeFromSuperview(view: UIView) {
        if self.isDescendant(of: view) {
            self.removeFromSuperview()
        }
    }
}

class EmptyAlertView: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    @IBOutlet weak var label_3: UILabel!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[index]
        
        label_1.textColor = currentTheme.textColor
        label_2.textColor = currentTheme.textColor
        label_3.textColor = currentTheme.textColor
        label_1.adjustsFontSizeToFitWidth = true
        label_2.adjustsFontSizeToFitWidth = true
        label_3.adjustsFontSizeToFitWidth = true
        self.backgroundColor = currentTheme.backgroundSeparatorColor
    }
    
    func presentView(view: UIView, icon_image: UIImage, label_1_text: String, label_2_text: String, label_3_text: String) {
        icon.image = icon_image
        label_1.text = label_1_text
        label_2.text = label_2_text
        label_3.text = label_3_text
        self.frame.size.width = UIScreen.main.bounds.width
        self.center = view.center
        view.addSubview(self)
    }
}

class DeleteAlertView: UIView {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[index]
        
        self.backgroundColor = currentTheme.backgroundSeparatorColor
        self.layer.cornerRadius = self.frame.width / 8
        self.frame.size.width = UIScreen.main.bounds.width -  40
        
        alertLabel.textColor = currentTheme.textColor
        
        deleteButtonOutlet.setTitleColor(currentTheme.textColor, for: .normal)
        deleteButtonOutlet.backgroundColor = currentTheme.separatorColor
        deleteButtonOutlet.layer.cornerRadius = deleteButtonOutlet.frame.width / 8
        
        cancelButtonOutlet.setTitleColor(currentTheme.textColor, for: .normal)
        cancelButtonOutlet.backgroundColor = currentTheme.separatorColor
        cancelButtonOutlet.layer.cornerRadius = deleteButtonOutlet.layer.cornerRadius
    }
    
    func presentDelterAlertView(view: UIView) {
        self.center = CGPoint(x: view.center.x, y: view.frame.height + self.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.center.y = view.center.y
            view.addSubview(self)
        }
    }
    
    func removeDeleteAlertView(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.center.y = view.frame.height + self.frame.height
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

class LogoutAlertView: UIView {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[index]
        
        self.backgroundColor = currentTheme.backgroundSeparatorColor
        self.layer.cornerRadius = self.frame.width / 16
        
        alertLabel.textColor = currentTheme.textColor
        alertLabel.textAlignment = .center
        alertLabel.text = User.language.log_out + " ?"
        
        logoutButtonOutlet.setTitleColor(currentTheme.backgroundColor, for: .normal)
        logoutButtonOutlet.backgroundColor = currentTheme.separatorColor
        logoutButtonOutlet.layer.cornerRadius = logoutButtonOutlet.frame.width / 8
        logoutButtonOutlet.setTitle("OK", for: .normal)
        
        cancelButtonOutlet.setTitleColor(currentTheme.backgroundColor, for: .normal)
        cancelButtonOutlet.backgroundColor = currentTheme.separatorColor
        cancelButtonOutlet.layer.cornerRadius = cancelButtonOutlet.frame.width / 8
        cancelButtonOutlet.setTitle(User.language.cancel, for: .normal)
    }
    
    func presentLogoutAlertView(view: UIView) {
        self.center = CGPoint(x: view.center.x, y: view.frame.height + self.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.center.y = view.center.y - self.frame.height / 2
            view.addSubview(self)
        }
    }
    
    func removeLogoutAlertView(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.center.y = view.frame.height + self.frame.height
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

class DelegateDelete {
    var indexPathSelected: IndexPath!
    var selectedLocal: Local!
}

class DelegateDelete1 {
    var indexPathSelected: IndexPath!
    var selectedEvent: Event!
}


class Time {
    
    private class func getDateFormat(dateString: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "hh:mm a"
        
        if let _ = inFormatter.date(from: dateString) { return "hh:mm a" }
        else { return "HH:mm" }
    }
    
    class func getTimetable(timetable: [String]) -> String {
        var dateFormat = String()
        let currentDate = Date()
        let currentDateFormatter = DateFormatter()
        var index = Int()
        
        for i in 0..<14 {
            if timetable[i] != "Close" {
                dateFormat = getDateFormat(dateString: timetable[i])
                break
            }
        }
        
        if currentDate.dayNumber == 1 { index = 6 } else { index = currentDate.dayNumber - 2 }
        
        currentDateFormatter.dateFormat = dateFormat
        let currentTime = currentDateFormatter.string(from: currentDate)
        
        let fromTime = timetable[ 2 * index]
        let toTime = timetable[2 * index + 1]
        
        if currentTime > fromTime && currentTime < toTime {
            return User.language.open
        } else {
            return User.language.close
        }
    }
}

class Notifications: Codable {
    
    var user_id: String
    var content: String
    var target: String?
    
    init(user_id: String, content: String, target: String?) {
        self.user_id = user_id
        self.content = content
        self.target = target
    }
    
    class func setForLocals(user_name: String, local_name: String) -> String {
        return "Hey \(user_name) \(local_name) has just open in your area!"
    }
    
    class func setForEvents(local_name: String, event_name: String) -> String {
        return "\(local_name) has just set up new event: \(event_name)."
    }
    
    class func setForEventLike(user_name: String, event_name: String) -> String {
        return "\(user_name) has just \(User.language.like!.lowercased()) \(event_name)."
    }
    
    class func setForNewEvent(user_name: String, event_name: String) -> String {
        return "\(user_name) has just decided \(User.language.going!.lowercased()) to \(event_name)."
    }
    
    class func setForFollow(user_id: String) -> String {
        return "\(user_id) started following you."
    }
    
    class func setForReply(user_name: String) -> String {
        return "\(user_name) replied to your discussion."
    }
    
    class func formatNotificationJSON(user_id: String, content: String, target: String?) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let notification = Notifications(user_id: user_id, content: content, target: target)
        
        let data = try! encoder.encode(notification)
        let json = String(data: data, encoding: .utf8)!
        
        return json
    }
}
