//
//  UnitsSettingsTVCCells.swift
//  eventsProject
//
//  Created by Pietro Putelli on 01/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

class MeasureUnitsTitleCell: UITableViewCell {
    
    @IBOutlet weak var measureUnitsTitle: UILabel!
}

class UnitCell: UITableViewCell {
    
    @IBOutlet weak var checkView: UIImageView!
    @IBOutlet weak var measureLabel: UILabel!
}

class AreaOfInterestTitleCell: UITableViewCell {
    
    @IBOutlet weak var areaOfInterestTitleLabel: UILabel!
}

class AreaOfInterestCell: UITableViewCell {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}

class DateTypeTitleCell: UITableViewCell {
    
    @IBOutlet weak var dateTypeTitleLabel: UILabel!
}

class DateTypeCell: UITableViewCell {
    
    @IBOutlet weak var dateTypeLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
}
