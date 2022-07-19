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
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let emailAddress: String
    let location: String
    let photoURL: String
    let parameters: [String]

    init(userModel: UserModel){
        self.userModel = userModel
        self.firstName = userModel.firstName ?? ""
        self.lastName = userModel.lastName ?? ""
        self.phoneNumber = userModel.phoneNumber ?? ""
        self.emailAddress = userModel.emailAddress ?? ""
        self.location = userModel.location ?? ""
        self.photoURL = userModel.photoURL ?? "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg"
        self.parameters = userModel.parameters ?? []
    }
    
    
    var body: some View {
       
        VStack{
            
                LazyImage(source: URL(string: photoURL)!){ state in
                    if let image = state.image {
                        image
                    } else if state.error != nil {
                       
                    } else {
                        ZStack{
                    
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                       .fill(.gray)
                                       .frame(width: 200, height: 200)
                            
                            Text(firstName.prefix(1)+" "+lastName.prefix(1))
                                .font(.system(size: 60))
                                .bold()
                            
                            
                        }
                    }
                }

        VStack  {
            Text("\(firstName) \(lastName)")
                .font(.system(size: 30))
                .fontWeight(.heavy)
            
            HStack{
                Text("iOS Engineer")
                
            }
            
            HStack{
                
                HStack(spacing: 8){
                    Image(systemName: "map").resizable().frame(width: 15, height: 20)
                    Text(location)
                }.padding(8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                
                HStack(spacing: 8){
                    Image(systemName: "suitcase").resizable().frame(width: 20, height: 20)
                }.padding(8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                
            }
            
            
            HStack(spacing: 8){
                Text("+1 " + phoneNumber)
            }.padding(8)
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            
            HStack{
                Button(action: {//messagesOpener()
                    sendMessage(phoneNumber: phoneNumber)
                }) {
                    Image(systemName: "message")
                        .font(.title2)
                        .frame(width: 110, height: 60)
                        .modifier(ButtonBG())
                        .cornerRadius(30)
                        .border(Color.blue, width: 2, cornerRadius: 25)
                }
                .padding()
                
                .modifier(ThemeShadow())
                Button(action: {
                    var phoneNumber = phoneNumber
                    guard let number = URL(string: "tel://" + phoneNumber) else { return }
                    if UIApplication.shared.canOpenURL(number) {
                        UIApplication.shared.open(number)
                    } else {
                        print("Can't open url on this device")
                    }
                    
                })  {   Image(systemName: "phone")
                        .font(.title2)
                        .frame(width: 110, height: 60)
                        .modifier(ButtonBG())
                        .cornerRadius(30)
                        .border(Color.blue, width: 2, cornerRadius: 25)
                    
                }
                .modifier(ThemeShadow())
            }
            
             
            VStack{
                let words = parameters
                ZStack{
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        let data = words.map { " \($0)" }
                         let screenWidth = UIScreen.main.bounds.width
                        
                        let columns = [
                            GridItem(.fixed(screenWidth-200)),
                            GridItem(.flexible()),
                            //GridItem(.flexible())
                        ]
                        
                        ZStack{
                            
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(data, id: \.self) { item in
                                        Button {
                                            
                                        } label: {
                                            Text(item)
                                                .frame(width: screenWidth-250, height: 50)
                                            //.padding()
                                                .background(Color.black)
                                                .foregroundColor(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                        }
                                    }
                                    
                                    .frame(maxHeight: 50)
                                }
                            }
                        }
                    }
                }
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
            photoURL: "https://firebasestorage.googleapis.com:443/v0/b/jackfruit-c9dab.appspot.com/o/users%2F5555555555.jpg?alt=media&token=a9925d3e-df7a-4959-b21d-160abf8763c5",
            parameters: ["pets", "traveling"])
                       )
    }
}
