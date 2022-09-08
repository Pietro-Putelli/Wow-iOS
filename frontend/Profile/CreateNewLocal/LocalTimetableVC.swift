//
//  LocalTimetableVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 25/08/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    @IBOutlet var fromTF: UITextField!
    @IBOutlet var toTF: UITextField!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet weak var closeButtonOutlet: UIButton!
}

extension LocalTimetableVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTF = textField
    }
}

extension LocalTimetableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dayCell = tableView.dequeueReusableCell(withIdentifier: "dayCellID", for: indexPath) as! DayCell
        dayCell.backgroundColor = currentTheme.backgroundColor
        
        dayCell.dayLabel.text = daysName[indexPath.row]
        
        dayCell.fromTF.inputView = datePickerView
        dayCell.fromTF.delegate = self
        dayCell.fromTF.textColor = currentTheme.textColor
        dayCell.fromTF.attributedPlaceholder = NSAttributedString(string: "From", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        dayCell.fromTF.borderStyle = .none
        dayCell.fromTF.layer.backgroundColor = currentTheme.backgroundColor.cgColor
        dayCell.fromTF.layer.masksToBounds = false
        dayCell.fromTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        dayCell.fromTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        dayCell.fromTF.layer.shadowOpacity = 1.0
        dayCell.fromTF.layer.shadowRadius = 0.0
        
        if indexPath.row == 0 { dayCell.fromTF.becomeFirstResponder() }
        
        dayCell.toTF.inputView = datePickerView
        dayCell.toTF.delegate = self
        dayCell.toTF.textColor = currentTheme.textColor
        dayCell.toTF.attributedPlaceholder = NSAttributedString(string: "To", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
        dayCell.toTF.borderStyle = .none
        dayCell.toTF.layer.backgroundColor = currentTheme.backgroundColor.cgColor
        dayCell.toTF.layer.masksToBounds = false
        dayCell.toTF.layer.shadowColor = currentTheme.separatorColor.cgColor
        dayCell.toTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.7)
        dayCell.toTF.layer.shadowOpacity = 1.0
        dayCell.toTF.layer.shadowRadius = 0.0
        
        dayCell.closeButtonOutlet.layer.cornerRadius = dayCell.closeButtonOutlet.frame.width / 16
        dayCell.closeButtonOutlet.tag = 8 * (indexPath.row + 1)
        
        if !dayCells.contains(dayCell) {
            dayCells.append(dayCell)
            
            if !timetable.isEmpty {
                dayCell.fromTF.text = timetable[timetableIndex]
                if timetable[timetableIndex] == "Close" {
                    dayCell.closeButtonOutlet.backgroundColor = closeButtonTintColor
                    dayCell.closeButtonOutlet.setTitle("CLOSE", for: .normal)
                    dayCell.closeButtonOutlet.tag /= 8
                    dayCell.fromTF.isEnabled = false
                    dayCell.toTF.isEnabled = false
                }
                timetableIndex += 1
                dayCell.toTF.text = timetable[timetableIndex]
                timetableIndex += 1
            }
        }
        return dayCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysName.count
    }
}

class LocalTimetableVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var selectedTF = UITextField()
    var doneButton = UIButton()
    
    var datePickerView = UIDatePicker()
    var dayCell = DayCell()
    var dayCells = [DayCell]()
    var timeString = String()
    var timetableIndex = Int()
    
    var datePickerViewHeight = CGFloat()
    
    let daysName = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var closeIdexPaths = [IndexPath]()
    var timetable = [String]()
    
    var closeButtonTintColor = UIColor()
    var openButtonTintColor = UIColor()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        datePickerView.datePickerMode = .time
        datePickerView.addTarget(self, action: #selector(LocalTimetableVC.dateChanged(datePicker:)), for: .valueChanged)
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        closeButtonTintColor = UIColor(red: 147/255, green: 7/255, blue: 0/255, alpha: 1)
        openButtonTintColor = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
        
        if let timetable = UserDefaults.standard.value(forKey: "LOCAL_TIMETABLE") as? [String] {
            self.timetable = timetable
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        if sender.tag % 8 == 0 {
            sender.alpha = 0
            sender.backgroundColor = closeButtonTintColor
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1
            }
            sender.setTitle("CLOSE", for: .normal)
            sender.tag /= 8
            
            let index = sender.tag - 1
            let dayCell = dayCells[index]
            dayCell.fromTF.isEnabled = false
            dayCell.toTF.isEnabled = false
            dayCell.fromTF.text = "Close"
            dayCell.toTF.text = "Close"
        } else {
            sender.alpha = 0
            sender.backgroundColor = openButtonTintColor
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1
            }
            sender.setTitle("OPEN", for: .normal)
            sender.tag *= 8
            
            let index = (sender.tag / 8) - 1
            let dayCell = dayCells[index]
            dayCell.fromTF.isEnabled = true
            dayCell.toTF.isEnabled = true
            dayCell.fromTF.text = ""
            dayCell.toTF.text = ""
        }
    }
    
    func numberOfEmptyClose() -> [Int] {
        var numberOfEmpty = 0
        var numberOfClose = 0
        var numberOfIllegal = 0
        for i in 0..<dayCells.count {
            if (dayCells[i].fromTF.text?.isEmpty)! || (dayCells[i].toTF.text?.isEmpty)! {
                numberOfEmpty += 1
            }
            if dayCells[i].fromTF.text == "Close" {
                numberOfClose += 1
            }
            if dayCells[i].fromTF.text != "Close" && !(dayCells[i].fromTF.text?.isEmpty)! {
                let fromDateString = dayCells[i].fromTF.text!
                let toDateString = dayCells[i].toTF.text!
                
                let inFormatter = DateFormatter()
                inFormatter.dateFormat = self.getDateFormat(dateString: fromDateString)
                
                let outFormatter = DateFormatter()
                outFormatter.dateFormat = inFormatter.dateFormat
                
                let date1 = inFormatter.date(from: fromDateString)
                let date2 = inFormatter.date(from: toDateString)
                
                let fromDate = outFormatter.string(from: date1!)
                let toDate = outFormatter.string(from: date2!)
                
                if fromDate > toDate {
                    numberOfIllegal += 1
                    self.shakeTextField(textField: dayCells[i].toTF)
                }
            }
        }
        return [numberOfEmpty,numberOfClose, numberOfIllegal]
    }
    
    func getDateFormat(dateString: String) -> String {
        
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "hh:mm a"
        
        if let _ = inFormatter.date(from: dateString) { return "hh:mm a" }
        else { return "HH:mm" }
    }
    
    func formatTimetable() -> [String] {
        var timetable = [String]()
        for i in 0..<dayCells.count {
            let fromText = dayCells[i].fromTF.text!
            let toText = dayCells[i].toTF.text!
            timetable.append(fromText)
            timetable.append(toText)
        }
        return timetable
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        selectedTF.text = timeFormatter.string(from: datePicker.date)
    }
    
    @objc func doneButtonAction() {
        
        print(dayCells.count)
        
        let parameter = self.numberOfEmptyClose()
        
        if parameter[0] == 0 && parameter[1] < 7 && parameter[2] == 0 {
            navigationController?.popViewController(animated: true)
            let timetable = self.formatTimetable()
            UserDefaults.standard.set(timetable, forKey: "LOCAL_TIMETABLE")
            print(timetable)
        }
    }
    
    func shakeTextField(textField:UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: textField.center.x - 10, y: textField.center.y)
        animation.toValue = CGPoint(x: textField.center.x + 10, y: textField.center.y)
        
        textField.layer.add(animation, forKey: "position")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        datePickerView.setValue(currentTheme.textColor, forKeyPath: "textColor")
        datePickerView.backgroundColor = currentTheme.backgroundSeparatorColor
        view.backgroundColor = currentTheme.backgroundColor
        
        tableView.backgroundColor = currentTheme.backgroundColor
        tableView.separatorColor = currentTheme.separatorColor
        tableView.contentInset = UIEdgeInsetsMake(0, 0, datePickerView.frame.height, 0)

        if let timetable = UserDefaults.standard.value(forKey: "LOCAL_TIMETABLE") as? [String] {
            self.timetable = timetable
        }
    }
}
