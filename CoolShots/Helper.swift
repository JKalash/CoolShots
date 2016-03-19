//
//  Helper.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func colorFromHex(hex : Int) -> UIColor {
    
        let red : CGFloat = CGFloat((hex & 0xFF0000) >> 16) / CGFloat(255)
        let green : CGFloat = CGFloat((hex & 0x00FF00) >> 8) / CGFloat(255)
        let blue : CGFloat = CGFloat((hex & 0x0000FF) >> 0) / CGFloat(255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func appColor() -> UIColor {
        return colorFromHex(0x47CA74)
    }

}
