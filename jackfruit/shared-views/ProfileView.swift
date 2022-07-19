//
//  LottieView.swift
//  cardView
//
//  Created by Aryan Mahindra on 7/17/22.
//


// text and call bith bigger
// both on the lower end
// below professional
// grid like


import SwiftUI
import NukeUI
import PhoneNumberKit
import Awesome

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

//TODO: implement default profile photo (don't use Juan)
// Implement call/text to actual number
// Add some orange colour accent (maybe shadow) to keep theme consistent
// Maybe make big rounded box (Bumble style) as contact photo
// Format activities, can define a map with emojis for each and displauy them
struct ProfileView: View {
    
    @State var show = false
    let userModel: UserModel
    //    let firstName: String
    //    let lastName: String
    //    let phoneNumber: String
    //    let emailAddress: String
    //    let location: String
    //    let photoURL: String
    //    let parameters: [String]
    
    init(userModel: UserModel){
        self.userModel = userModel
        //        self.firstName = userModel.firstName ?? ""
        //        self.lastName = userModel.lastName ?? ""
        //        self.phoneNumber = userModel.phoneNumber ?? ""
        //        self.emailAddress = userModel.emailAddress ?? ""
        //        self.location = userModel.location ?? ""
        //        self.photoURL = userModel.photoURL ?? "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg"
        //        self.parameters = userModel.parameters ?? []
    }
    
    
    var body: some View {
        VStack{
            VStack {
                let photoURL = userModel.photoURL ?? ""
                LazyImage(source: URL(string: photoURL)) { state in
                    if let image = state.image {
                        image
                            .frame(width: 300, height: 300, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.init(UIColor.transitionPage), lineWidth: 10))
                            .padding(.top, 20)
                    } else if state.error != nil {
                        
                    } else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color(UIColor.transitionPage))
                                .frame(width: 300, height: 300)
                            
                            Text(userModel.firstName!.prefix(1)+" "+userModel.lastName!.prefix(1))
                                .font(Font.custom("CircularStd-Book", size: 30))
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                }
                .overlay(TextOverlay(firstName: userModel.firstName!, lastName: userModel.lastName!, companyName: userModel.companyName ?? "", companyPosition: userModel.companyPosition ?? ""), alignment: .bottomTrailing)
            }
            
            HStack {
                Button(action: {//messagesOpener()
                    sendMessage(phoneNumber: userModel.phoneNumber!)
                }) {
                    Image(systemName: "message")
                        .font(Font.custom("CircularStd-Book", size: 30))
                        .frame(width: 70, height: 40)
                        .modifier(ButtonBG())
                        .cornerRadius(30)
                        .border(Color.black, width: 2, cornerRadius: 25)
                }
                
                
                .modifier(ThemeShadow())
                Button(action: {
                    let phoneNumber = userModel.phoneNumber!
                    guard let number = URL(string: "tel://" + phoneNumber) else { return }
                    if UIApplication.shared.canOpenURL(number) {
                        UIApplication.shared.open(number)
                    } else {
                        print("Can't open url on this device")
                    }
                    
                })  {   Image(systemName: "phone")
                        .font(Font.custom("CircularStd-Book", size: 30))
                        .frame(width: 70, height: 40)
                        .modifier(ButtonBG())
                        .cornerRadius(30)
                        .border(Color.black, width: 2, cornerRadius: 25)
                    
                }
                .modifier(ThemeShadow())
            }
            
            ScrollView {
                VStack  {
                    HStack {
                        HStack(spacing: 5){
                            Image(systemName: "location.circle")
                            Text(userModel.location!)
                        }
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        //.frame(width:20, height: 20)
                        
                        HStack(spacing: 5){
                            Image(systemName: "phone")
                            Text("+1 " + userModel.phoneNumber!).font(Font.custom("CircularStd-Book", size: 20))
                        }//.padding(8)
                        
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        
                    }//.padding(.vertical, 15)
                    
                    VStack{
                        Text("\(userModel.firstName ?? "Contact")'s Interests").font(Font.custom("CircularStd-Black", size: 20))
                            .foregroundColor(Color.black)
                        
                        let words = userModel.parameters!
                        ZStack{
                            Color.white
                                .edgesIgnoringSafeArea(.all)
                            VStack{
                                let data = words.map { " \($0)" }
                                let screenWidth = UIScreen.main.bounds.width
                                
                                let columns = [
                                    GridItem(.fixed(screenWidth-200)),
                                    GridItem(.flexible()),
                                ]
                                
                                ZStack{
                                    LazyVGrid(columns: columns, spacing: 5) {
                                        ForEach(data, id: \.self) { item in
                                            Text(activityText[item] ?? item)
                                                .font(Font.custom("CircularStd-Black", size: 16))
                                                .frame(width: screenWidth-250, height: 40)
                                                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(Color(UIColor.transitionPage)))
                                                .foregroundColor(Color.white)
                                        }
                                        
                                        .frame(maxHeight: 50)
                                    }.background(Color.init(UIColor.middleColor))
                                }
                            }
                        }
                    }
                    VStack {
                        Text("Professional").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        if userModel.linkedinURL != nil && userModel.linkedinURL != "" {
                            HStack {
                                Awesome.Brand.linkedin.image
                                    .size(25)
                                Text(userModel.linkedinURL!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                        
                        if userModel.githubURL != nil && userModel.githubURL != "" {
                            HStack {
                                Awesome.Brand.github.image
                                    .size(25)
                                Text(userModel.githubURL!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                    }.padding()
                    
                    VStack {
                        Text("Social Networking").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        
                        if userModel.instagramURL != nil && userModel.instagramURL != "" {
                            HStack {
                                Awesome.Brand.instagram.image
                                    .size(25)
                                Text(userModel.instagramURL!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                        if userModel.snapchatURL != nil && userModel.snapchatURL != "" {
                            HStack {
                                Awesome.Brand.snapchat.image
                                    .size(25)
                                Text(userModel.snapchatURL!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                        if userModel.twitterURL != nil && userModel.twitterURL != "" {
                            HStack {
                                Awesome.Brand.twitter.image
                                    .size(25)
                                Text(userModel.twitterURL!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                    }.padding()
                    
                    VStack{
                        Text("Personal").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        if userModel.hometown != nil && userModel.hometown != "" {
                            HStack {
                                Awesome.Solid.home.image
                                    .size(25)
                                Text(userModel.hometown!).font(Font.custom("CircularStd-Book", size: 14))
                                    .foregroundColor(.black)
                                
                            }
                        }
                        if (userModel.universityName != nil && userModel.universityName != "") || (userModel.universityDegree != nil && userModel.universityDegree != "") {
                            HStack {
                                Awesome.Solid.graduationCap.image
                                    .size(25)
                                if userModel.universityName != nil && userModel.universityName != ""{
                                    Text(userModel.universityName!).font(Font.custom("CircularStd-Book", size: 14))
                                        .foregroundColor(.black)
                                }
                                if userModel.universityDegree != nil && userModel.universityDegree != "" {
                                    Text(userModel.universityDegree!).font(Font.custom("CircularStd-Book", size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        if (userModel.birthMonth != nil && userModel.birthMonth != "") || (userModel.birthNumber != nil && userModel.birthNumber != "") {
                            HStack {
                                Awesome.Solid.graduationCap.image
                                    .size(25)
                                if userModel.birthMonth != nil && userModel.birthMonth != ""{
                                    Text(userModel.birthMonth!).font(Font.custom("CircularStd-Book", size: 14))
                                        .foregroundColor(.black)
                                }
                                if userModel.birthNumber != nil && userModel.birthNumber != "" {
                                    Text(userModel.birthNumber!).font(Font.custom("CircularStd-Book", size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }.padding()
                }
                
            }
        }
    }
    
    private func messagesOpener(){
        
        
        
        //            if let url = URL(string: UIApplication.openSettingsURLString) {
        //                if UIApplication.shared.canOpenURL(url) {
        //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //                }
        //            }
        
        
        if UIApplication.shared.canOpenURL(URL(string:"sms:")!) {
            UIApplication.shared.open(URL(string:"sms:")!, options: [:], completionHandler: nil)
        }
    }
}


func phoneOpener(){
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}



func sendMessage(phoneNumber: String){
    
    
    
    let smsNumber = ""+phoneNumber
    
    let sms: String = "sms:+\(phoneNumber)&body=Hi, it was great meeting you today!"
    let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
}





struct ButtonBG: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor(named: "themeButtonBG") ?? UIColor.secondarySystemBackground))
    }
}

struct ThemeShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(UIColor.black).opacity(0.1), radius: 8)
    }
}

struct RoundedRectangleAroundText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.green)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.green, lineWidth: 3)
            )
            .offset(x: 30)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userModel: UserModel(
            firstName: "Marcus",
            lastName: "Deans",
            emailAddress: "marcusddeans@outlook.com",
            phoneNumber: "9196414032",
            location: "San Francisco",
            photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
            parameters: ["pets", "traveling"],
            companyName: "Atomic",
            snapchatURL: "snapchat.com/marcus_deans", hometown: "Windsor")
        )
    }
}
