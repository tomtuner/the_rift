//
//  TRTheme.swift
//  The Rift
//
//  Created by Thomas.Demeo on 11/9/15.
//  Copyright © 2015 American Well. All rights reserved.
//

import UIKit
import Foundation

class TRTheme: NSObject {
    
    class func applyTheme() {
        self.applyThemeToTableCells()
    }
    
    class func applyThemeToTableCells() {
        UINavigationBar.appearance().backgroundColor = self.leagueGreenHealthBarColor()
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewCell.self]).textColor = self.leagueGreenHealthBarColor()
    }
    
    class func leagueGreenHealthBarColor() -> UIColor {
        return UIColor(red: 1.00, green:  0.8431372549, blue: 0.0, alpha: 1.0)
    }
    
}