//
//  ThemesStructure.swift
//  eventsProject
//
//  Created by Pietro Putelli on 03/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

struct Themes {
    
    var barColor: UIColor
    var backgroundColor: UIColor
    var separatorColor: UIColor
    var selectedColor: UIColor
    var textColor: UIColor
    var backgroundSeparatorColor: UIColor
    var keyboardLook: UIKeyboardAppearance
    var selectedItemColor: UIColor
    var notSelectedItemColor: UIColor
    var navBackgroundViewColor: UIColor
    var blurStyle: UIBlurEffectStyle
    
    static func setArrayThemes() -> [Themes] {
        
        let classicBarColor = UIColor(red: 3/255, green: 55/255, blue: 120/255, alpha: 1)
        let darkBlueBarColor = UIColor(red: 8/255, green: 25/255, blue: 75/255, alpha: 1)
        let darkBarColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        
        let classicBackgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        let darkBlueBackgroundColor = UIColor(red: 10/255, green: 27/255, blue: 52/255, alpha: 1)
        let darkBackgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        
        let classicSeparatorColor = UIColor(red: 0/255, green: 84/255, blue: 150/255, alpha: 1)
        let darkBlueSeparatorColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        let darkSeparatorColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        
        let classicSelectedColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        let darkBlueSelectedColor = UIColor(red: 14/255, green: 37/255, blue: 72/255, alpha: 1)
        let darkSelectedColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1)
        
        let classicTextColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let darkBlueTextColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        let darkTextColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        
        let classicBackgroundSeparatorColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        let darkBlueBackgroundSeparatorColor = UIColor(red: 5/255, green: 20/255, blue: 35/255, alpha: 1)
        let darkBackgroundSeparatorColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        let classicSelectedItemColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        let darkBlueSelectedItemColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        let darkSelectedItemColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        
        let classicNotSelectedItemColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        let darkBlueNotSelectedItemColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        let darkNotSelectedItemColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
        
        let classicNavBackgroundViewColor = UIColor(red: 25/255, green: 69/255, blue: 124/255, alpha: 1)
        let darkBlueNavBackgroundViewColor = UIColor(red: 30/255, green: 44/255, blue: 87/255, alpha: 1)
        let darkNavBackgroundViewColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        
        let barColors = [darkBarColor,darkBlueBarColor,classicBarColor]
        let backgroundColors = [darkBackgroundColor,darkBlueBackgroundColor,classicBackgroundColor]
        let separatorColors = [darkSeparatorColor,darkBlueSeparatorColor,classicSeparatorColor]
        let selectedColors = [darkSelectedColor,darkBlueSelectedColor,classicSelectedColor]
        let textColors = [darkTextColor,darkBlueTextColor,classicTextColor]
        let backgroundSeparatorColors = [darkBackgroundSeparatorColor,darkBlueBackgroundSeparatorColor,classicBackgroundSeparatorColor]
        let selectedItemColors = [darkSelectedItemColor,darkBlueSelectedItemColor,classicSelectedItemColor]
        let notSelectedItemColors = [darkNotSelectedItemColor,darkBlueNotSelectedItemColor,classicNotSelectedItemColor]
        let navBackgroundViewColor = [darkNavBackgroundViewColor,darkBlueNavBackgroundViewColor,classicNavBackgroundViewColor]
        let keyboardLooks: [UIKeyboardAppearance] = [.dark,.dark,.default]
        let blursEffects: [UIBlurEffectStyle] = [.dark,.dark,.light]
        
        var themes = [Themes]()
        
        for i in 0...2 {
            
            let theme = Themes(barColor: barColors[i], backgroundColor: backgroundColors[i], separatorColor: separatorColors[i], selectedColor: selectedColors[i], textColor: textColors[i], backgroundSeparatorColor: backgroundSeparatorColors[i], keyboardLook: keyboardLooks[i], selectedItemColor:
                selectedItemColors[i], notSelectedItemColor: notSelectedItemColors[i], navBackgroundViewColor: navBackgroundViewColor[i], blurStyle: blursEffects[i])
            themes.append(theme)
        }
        
        return themes
    }
}
