//
//  Theme.swift
//  contacts-frontend
//
//  Created by Marcus Deans on 2022-06-21.
//

import SwiftUI

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
            let newRed = CGFloat(red)/255
            let newGreen = CGFloat(green)/255
            let newBlue = CGFloat(blue)/255
            
            self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
    
    convenience init(rgb: Int) {
           self.init(
               red: (rgb >> 16) & 0xFF,
               green: (rgb >> 8) & 0xFF,
               blue: rgb & 0xFF
           )
       }
    
    static let darkColor = UIColor(rgb: 0x254441)
    static let midColor = UIColor(rgb: 0x43AA8B)
    static let brightColor = UIColor(rgb: 0xFF6F59)
 
    static let afterStartPageTransition = UIColor(rgb: 0x44AA92)
    static let underLine = UIColor(rgb: 0x9667E0)
    
    
    static let activitiesLeft = UIColor(rgb: 0xFFC900)
    
    static let activitiesRight = UIColor(rgb: 0xFFB700)
    
    
    static let transitionPage = UIColor(rgb: 0xff5400)
    
    static let middleColor = UIColor(rgb: 0xf0f2f7)
    
    static let textColor = UIColor(rgb: 0x4d5764)
    static let smalltextColor = UIColor(rgb: 0xcbcdd3)
    
    
    static let cardColor = UIColor(rgb: 0xfefefe)
    
 
    static let redGradient = UIColor(rgb : 0xff7900)
    
    
    static let greenShaddow = UIColor(rgb: 0x628343)
    static let greenBackground = UIColor(rgb: 0x8CC152)
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let contactCardColor = UIColor(rgb: 0xFFE6D9)
    
    
    static let greenStatusBar = UIColor(rgb: 0x4D643C)
    
}

enum Field: Int, CaseIterable {
    case firstName, lastName, phoneNumber, verificationCode, emailAddress, location, parameters
}
