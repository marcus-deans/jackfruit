//
//  Theme.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
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
    static let transitionPage = UIColor(rgb: 0x8CC152)
    static let greenShaddow = UIColor(rgb: 0x628343)
    static let greenBackground = UIColor(rgb: 0x8CC152)
    
    static let greenStatusBar = UIColor(rgb: 0x4D643C)
    
}
