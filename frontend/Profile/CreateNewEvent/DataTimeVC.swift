//
//  DataTimeTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 23/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class FromDateCell: UITableViewCell {
    @IBOutlet weak var fromTitleLabel: UILabel!
    @IBOutlet weak var fromTF: UITextField!
}

class ToDateCell: UITableViewCell {
    @IBOutlet weak var toTitleLabel: UILabel!
    @IBOutlet weak var toTF: UITextField!
}

class AtDateCell: UITableViewCell {
    @IBOutlet weak var atTitleLabel: UILabel!
    @IBOutlet weak var atTF: UITextField!
}

class SummaryCell: UITableViewCell {
    @IBOutlet weak var summaryTitleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
}

extension DateTimeVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTF = textField
        
        if textField != atCell.atTF {
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
        } else {
            datePicker.datePickerMode = .time
        }
    }
}

class DateTimeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var datePicker = UIDatePicker()
    var selectedTF = UITextField()
    var doneButton = UIButton()
    var backgroundColorView = UIView()
    
    var fromCell = FromDateCell()
    var toCell = ToDateCell()
    var atCell = AtDateCell()
    var summaryCell = SummaryCell()

    var summaryText = String()
    
    var fromDate = String()
    var toDate = String()
    var atDate = String()
    
    var INVALID_TEXT_ERROR = String()

    var selectedEvent: Event?
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
    
        tableView.delegate = self
        tableView.dataSource = self
        
        datePicker.addTarget(self, action: #selector(DateTimeVC.dateChanged(datePicker:)), for: .valueChanged)
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        doneButton.setImage(#imageLiteral(resourceName: "checkIcon1").withRenderingMode(.alwaysTemplate), for: .normal)
        doneButton.tintColor = .white
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)
        doneButton.isEnabled = false
        
        INVALID_TEXT_ERROR = "Invalid date"
        
        if let fromDate = UserDefaults.standard.value(forKey: "FROM_DATE") as? String,
            let toDate = UserDefaults.standard.value(forKey: "TO_DATE") as? String,
            let atDate = UserDefaults.standard.value(forKey: "AT_TIME") as? String {

            self.fromDate = fromDate
            self.toDate = toDate
            self.atDate = atDate

            doneButton.isEnabled = true
        }
        
        if selectedEvent != nil {
            doneButton.isEnabled = true
        }
    }
    
    @objc func dismissDatePicker() {
        
        UserDefaults.standard.set(fromDate, forKey: "FROM_DATE")
        UserDefaults.standard.set(toDate, forKey: "TO_DATE")
        UserDefaults.standard.set(atDate, forKey: "AT_TIME")
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
    
        if selectedTF != atCell.atTF {
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd-MMM-yyyy", options: 0, locale: NSLocale.current)
            selectedTF.text = dateFormatter.string(from: datePicker.date)

        } else {
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: NSLocale.current)
            selectedTF.text = dateFormatter.string(from: datePicker.date)
        }
        
        if selectedTF == fromCell.fromTF {
            fromDate = selectedTF.text!
        } else if selectedTF == toCell.toTF {
            toDate = selectedTF.text!
        } else {
            atDate = selectedTF.text!
        }
        
        if !checkDateValidity(from: fromDate, to: toDate) {
            selectedTF.text = INVALID_TEXT_ERROR
        }
        
        if !fromDate.isEmpty && !toDate.isEmpty && !atDate.isEmpty && fromCell.fromTF.text != INVALID_TEXT_ERROR && toCell.toTF.text != INVALID_TEXT_ERROR {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
        
        summaryText = "From: \(fromDate) to: \(toDate) at: \(atDate)"
        summaryCell.summaryLabel.text = summaryText
    }
    
    func checkDateValidity(from: String, to: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd", options: 0, locale: NSLocale.current)
        
        let fromDate = dateFormatter.date(from: from)
        let toDate = dateFormatter.date(from: to)
        
        if fromDate != nil && toDate != nil {
            if fromDate! > toDate! { return false }
            else if toDate! < fromDate! { return false }
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        view.backgroundColor = currentTheme.backgroundColor
        backgroundColorView.backgroundColor = currentTheme.selectedColor
        tableView.backgroundColor = currentTheme.backgroundColor
        navigationItem.title = User.language.date_time
        
        datePicker.backgroundColor = currentTheme.backgroundColor
        datePicker.setValue(currentTheme.textColor, forKeyPath: "textColor")
        
        if let selectedEvent = selectedEvent {
            fromDate = selectedEvent.fromDate
            toDate = selectedEvent.toDate
            atDate = selectedEvent.atDate
            doneButton.isEnabled = true
        } else if let fromDate = UserDefaults.standard.value(forKey: "FROM_DATE") as? String,
            let toDate = UserDefaults.standard.value(forKey: "TO_DATE") as? String,
            let atDate = UserDefaults.standard.value(forKey: "AT_TIME") as? String {
            
            self.fromDate = fromDate
            self.toDate = toDate
            self.atDate = atDate
            doneButton.isEnabled = true
        }
    }
}

extension DateTimeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            fromCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! FromDateCell
            fromCell.backgroundColor = currentTheme.backgroundColor
            fromCell.fromTitleLabel.textColor = currentTheme.textColor
            fromCell.fromTF.delegate = self
            fromCell.fromTF.inputView = datePicker
            fromCell.fromTF.textColor = currentTheme.textColor
            fromCell.fromTF.attributedPlaceholder = NSAttributedString(string: "From", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            fromCell.fromTF.becomeFirstResponder()
            
            if let fromText = UserDefaults.standard.value(forKey: "FROM_DATE") as? String {
                fromCell.fromTF.text = fromText
            } else if let selectedEvent = selectedEvent {
                fromCell.fromTF.text = selectedEvent.fromDate
            }
            
            return fromCell
            
        case 1:
            
            toCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ToDateCell
            toCell.backgroundColor = currentTheme.backgroundColor
            toCell.toTitleLabel.textColor = currentTheme.textColor
            toCell.toTF.delegate = self
            toCell.toTF.inputView = datePicker
            toCell.toTF.textColor = currentTheme.textColor
            toCell.toTF.attributedPlaceholder = NSAttributedString(string: "To", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            
            if let toText = UserDefaults.standard.value(forKey: "TO_DATE") as? String {
                toCell.toTF.text = toText
            } else if let selectedEvent = selectedEvent {
                toCell.toTF.text = selectedEvent.toDate
            }
            
            return toCell
            
        case 2:
            
            atCell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! AtDateCell
            atCell.backgroundColor = currentTheme.backgroundColor
            atCell.atTitleLabel.textColor = currentTheme.textColor
            atCell.atTF.delegate = self
            atCell.atTF.inputView = datePicker
            atCell.atTF.textColor = currentTheme.textColor
            atCell.atTF.attributedPlaceholder = NSAttributedString(string: "At", attributes: [NSAttributedStringKey.foregroundColor: currentTheme.textColor.withAlphaComponent(0.5)])
            
            if let atText = UserDefaults.standard.value(forKey: "AT_TIME") as? String {
                atCell.atTF.text = atText
            } else if let selectedEvent = selectedEvent {
                atCell.atTF.text = selectedEvent.atDate
            }
            
            return atCell
            
        case 3:
            
            summaryCell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! SummaryCell
            summaryCell.backgroundColor = currentTheme.backgroundColor
            summaryCell.summaryLabel.textColor = currentTheme.textColor
            summaryCell.summaryTitleLabel.textColor = currentTheme.textColor
            
            if let selectedEvent = selectedEvent {
                summaryCell.summaryLabel.text = "From \(selectedEvent.fromDate) to \(selectedEvent.toDate) at \(selectedEvent.atDate)"
            } else if let fromDate = UserDefaults.standard.value(forKey: "FROM_DATE") as? String,
                let toDate = UserDefaults.standard.value(forKey: "TO_DATE") as? String,
                let atDate = UserDefaults.standard.value(forKey: "AT_TIME") as? String {
                summaryCell.summaryLabel.text = "From \(fromDate) to \(toDate) at \(atDate)"
            }
            
            return summaryCell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}






