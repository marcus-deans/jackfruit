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
    
    static let lighttransition = UIColor(rgb: 0xFFE9DE)
    
    static let transitionPage = UIColor(rgb: 0xff5400)
    
    static let topGradient = UIColor(rgb: 0xFFA800)

    
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

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .foregroundColor(Color.init(.black))
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(Color.init(UIColor.underLine))
            .padding(10)
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        
            .border(Color.white)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .foregroundColor(.white)
                    .shadow(color: focused ? Color(UIColor.black).opacity(0.2) : Color(UIColor.clear).opacity(0.3), radius: 4, x: 0, y: 5)
            )
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {}, label: {
            HStack(alignment: .center) {
                
                configuration.label.foregroundColor(.black)
                    .font(Font.custom("CircularStd-Book", size: 20))
                
            }
        })
        // 👇🏻 makes all taps go to the original button
        //.frame(width:300) May need to change this back for onboarding
        .allowsHitTesting(false)
        .padding()
        .background(Color.white).cornerRadius(30)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {}, label: {
            HStack(alignment: .center) {
                
                configuration.label.foregroundColor(.black)
                    .font(Font.custom("CircularStd-Book", size: 20))
                
            }
        })
        // 👇🏻 makes all taps go to the original button
        //.frame(width:300) May need to change this back for onboarding
        .allowsHitTesting(false)
        .padding()
        .background(Color.yellow).cornerRadius(30)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .font(Font.custom("PTSans-Bold", size: 30))
            .foregroundColor(Color.white)
            .background(Color.black)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.greenStatusBar))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.black))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}


enum Field: Int, CaseIterable {
    case firstName, lastName, phoneNumber, verificationCode, emailAddress, location, parameters
}
