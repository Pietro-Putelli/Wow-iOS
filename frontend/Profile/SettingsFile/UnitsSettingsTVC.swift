//
//  UnitsSettingsTVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 30/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class UnitsSettingsTVC: UITableViewController {
    
    @IBOutlet weak var unitsSettingsNavBarTitle: UINavigationItem!
    
    var selectedCell = Int()
    var measureName = [User.language.km,User.language.ml]
    var measureUnit = String()
    var sliderValue = Float()
    var setInMeasureUnit = Int()
    let conversionFactor:Float = 0.62
    
    let sliderMlMax:Float = 62
    let sliderKmMax:Float = 100
    
    var isKmSelected = Bool()
    var isMlSelected = Bool()
    
    var isSelected = Bool()
    
    var selectedCellColor = UIView()
    
    var areaOfInterestCell = AreaOfInterestCell()
    var areOfInterestCellIndexPath = IndexPath()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()

    var currentLanguage: Language! = nil
    var languages = Language.languageFromBundle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
    
        if UserDefaults.standard.value(forKey: "USER_MEASURE_UNIT") != nil {selectedCell = UserDefaults.standard.value(forKey: "USER_MEASURE_UNIT") as! Int}
        else {selectedCell = 1}

        if let distanceValue = UserDefaults.standard.value(forKey: "AREA_OF_INTEREST") as? Float {
            sliderValue = distanceValue
        } else {
            let defaultValue:Float = 2.0
            sliderValue = defaultValue
        }
        
        if let measureUnit = UserDefaults.standard.value(forKey: "SET_IN_MEASURE_UNIT") as? Int {
            setInMeasureUnit = measureUnit
        } else {
            let defaultValue = 0
            setInMeasureUnit = defaultValue
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            selectedCell = indexPath.row
            UserDefaults.standard.set(selectedCell, forKey: "USER_MEASURE_UNIT")
            setInMeasureUnit = selectedCell
            UserDefaults.standard.set(setInMeasureUnit, forKey: "SET_IN_MEASURE_UNIT")
            tableView.reloadData()
        }
        
        if indexPath.row == 1 {
            selectedCell = indexPath.row
            UserDefaults.standard.set(selectedCell, forKey: "USER_MEASURE_UNIT")
            setInMeasureUnit = selectedCell
            UserDefaults.standard.set(setInMeasureUnit, forKey: "SET_IN_MEASURE_UNIT")
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0,1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath) as! UnitCell
            cell.measureLabel.text = measureName[indexPath.row]
            cell.checkView.image = nil
            
            if selectedCell == indexPath.row {
                cell.checkView.image = #imageLiteral(resourceName: "checkIcon")
            }
            
            cell.backgroundColor = currentTheme.backgroundColor
            cell.measureLabel.textColor = currentTheme.textColor
            cell.selectedBackgroundView = selectedCellColor
            
            let units = [User.language.km,User.language.ml]
            cell.measureLabel.text = units[indexPath.row]
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "areaOfInterestCell", for: indexPath) as! AreaOfInterestTitleCell
            cell.selectionStyle = .none
            cell.backgroundColor = tableView.backgroundColor
            cell.areaOfInterestTitleLabel.textColor = currentTheme.textColor
            return cell
            
        case 3:
            
            areaOfInterestCell = tableView.dequeueReusableCell(withIdentifier: "setAreaCell", for: indexPath) as! AreaOfInterestCell
            areaOfInterestCell.selectionStyle = .none
            areaOfInterestCell.backgroundColor = currentTheme.backgroundColor
            areaOfInterestCell.instructionLabel.textColor = currentTheme.textColor
            areaOfInterestCell.sliderValueLabel.textColor = currentTheme.textColor
            areaOfInterestCell.slider.minimumTrackTintColor = currentTheme.separatorColor
            areOfInterestCellIndexPath = indexPath
            
            if selectedCell == 1 {
            } else {
            }
            areaOfInterestCell.sliderValueLabel.text = String(1) + " " + measureUnit
            
            if selectedCell == 1 {
                areaOfInterestCell.slider.maximumValue = sliderKmMax
            } else {
                areaOfInterestCell.slider.maximumValue = sliderMlMax
            }
            
            if setInMeasureUnit == 1 && !isKmSelected {
                isKmSelected = true
                isMlSelected = false
                sliderValue /= conversionFactor
                setInMeasureUnit = 2
            } else if setInMeasureUnit == 2 && !isMlSelected {
                isMlSelected = true
                isKmSelected = false
                sliderValue *= conversionFactor
                setInMeasureUnit = 1
            }
            
            areaOfInterestCell.slider.setValue(sliderValue, animated: true)
            areaOfInterestCell.sliderValueLabel.text = String(Int(sliderValue)) + " " + measureUnit
            return areaOfInterestCell
            
        default: return UITableViewCell()
        }
    }
    
    @IBAction func sliderChangedValue(_ sender: UISlider) {
        sliderValue = sender.value
        UserDefaults.standard.set(sliderValue, forKey: "AREA_OF_INTEREST")
        areaOfInterestCell.sliderValueLabel.text = String(Int(sliderValue)) + " " + measureUnit
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        tableView.reloadData()
        tableView.backgroundColor = currentTheme.backgroundSeparatorColor
        tableView.separatorColor = currentTheme.separatorColor.withAlphaComponent(0.5)
        
        navigationController?.navigationBar.barTintColor = currentTheme.barColor
        navigationItem.title = User.language.measure_unit

        selectedCellColor.backgroundColor = currentTheme.selectedColor
    }
}
