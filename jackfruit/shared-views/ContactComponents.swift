//
//  ContactComponents.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-18.
//

import Foundation
import SwiftUI
import WrappingHStack
import NukeUI

var textEmojiMap = ["pets":"pets 🐶",
                    "traveling":"traveling ✈️",
                    "sports":"sports 🏈",
                    "hobbies":"hobbies 📖",
                    "creativity":"creativity 🎨",
                    "Duke University":"Duke 😈"]

struct ProfilePhotoView: View {
    let profileURL: String
    var body: some View {
        ZStack {
            let _ = print("Fetching URL from \(profileURL)")
            Text("")
                .shadow(radius: 4)
                .font(.largeTitle)
                .frame(width: 85, height: 75)
                .overlay(
                    LazyImage(source: URL(string: profileURL)){ state in
                        if let image = state.image {
                            image
                        } else if state.error != nil {
                            Image(systemName: "photo") // Indicates an error
                        } else {
                            ProgressView() // Acts as a placeholder
                        }
                    }
                        //.frame(maxWidth: 200, maxHeight: 150)
                        
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                )
    
        }
    }
}

struct ContactRowView: View {
    let userItem: UserModel
    var body: some View {
        
        VStack() {
            VStack(alignment: .center, spacing: 1) {
                //might cause a bug depending on the name size
                LargerProfileView().padding(.bottom, 40).padding(.trailing, 30)
                HStack{
                    Text(userItem.firstName!)
                        .font(Font.custom("PTSans-Bold", size: 24))
                    + Text(" ")
                        .font(Font.custom("PTSans-Bold", size: 24))
                    + Text(userItem.lastName!)
                        .font(Font.custom("PTSans-Bold", size: 24))
                }.padding(.bottom, 3).padding(.leading, 20)
                HStack{
                    Text(userItem.phoneNumber!)
                        .font(Font.custom("PTSans-Bold", size: 16))
                        .fontWeight(.black).bold()
                }
                HStack {
                    Text(userItem.emailAddress!)
                        .font(Font.custom("PTSans-Bold", size: 15))
                        .fontWeight(.black).bold()
                        .underlineTextField()
                    
                    HStack{
                        Text("Currently In ")
                            .font(Font.custom("PTSans-Bold", size: 20))
                            .fontWeight(.black).bold()
                        
                        Text(userItem.location!)
                            .font(Font.custom("PTSans-Bold", size: 15))
                            .fontWeight(.black).bold()
                            .underlineTextField()
                    }
                }
                Text("Interests")
                    .font(Font.custom("PTSans-Bold", size: 20))
                    .fontWeight(.black).bold()
            }
            WrappingHStack {
                ForEach(userItem.parameters!, id : \.self) { child in
                    SingleParameterView(title: child)
                }
            }
        }
        .padding()
        .navigationBarTitle(Text(userItem.firstName!), displayMode: .inline)
    }
    
}


struct SingleParameterView: View {
    var title: String
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.init(UIColor.transitionPage) , .init(UIColor.redGradient)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 40)
                    .padding(.horizontal, 5)
                
                VStack {
                    Text("\(title)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}


struct LargerProfileView: View {
    var body: some View {
        Image("Profilephoto").resizable().frame(width: 350.0, height: 250.0)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init(UIColor.redGradient), lineWidth: 5))
    }
}

struct TextOverlay: View{
    let firstName: String
    let lastName: String
    let companyName: String
    let companyPosition: String
    var body: some View {
        VStack (alignment: .trailing){
            Text("\(firstName) \(lastName)")
                .font(Font.custom("CircularStd-Book", size: 28))
                .foregroundColor(.white)
                .fontWeight(.heavy)
            
            if(companyName == "" && companyPosition != ""){
                Text("\(companyPosition)").font(Font.custom("CircularStd-Book", size:20))
                    .foregroundColor(.white)
            } else if
                (companyName != "" && companyPosition == ""){
                Text("Works at \(companyName)").font(Font.custom("CircularStd-Book", size:20))
                    .foregroundColor(.white)
            } else if (companyName != "" && companyPosition != ""){
                Text("\(companyPosition) at \(companyName)").font(Font.custom("CircularStd-Book", size: 20))
                    .foregroundColor(.white)
            }
        }.padding()
    }
}

struct ContactComponents_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView(userItem: UserModel(
            firstName: "Marcus", lastName: "Deans", emailAddress: "marcusddeans@outlook.com", phoneNumber: "9196414032", location: "San Francisco", photoURL: "https://firebasestorage.googleapis.com:443/v0/b/jackfruit-c9dab.appspot.com/o/users%2F5555555555.jpg?alt=media&token=a9925d3e-df7a-4959-b21d-160abf8763c5", parameters: ["pets", "traveling"])
                       )
        
        ZStack{
            Color(.black).edgesIgnoringSafeArea(.all)
//            TextOverlay(firstName: "Marcus", lastName: "Deans", companyName: "Atomic", companyPosition: "Software Engineer")
//            TextOverlay(firstName: "Marcus", lastName: "Deans", companyName: "", companyPosition: "Software Engineer")
            TextOverlay(firstName: "Marcus", lastName: "Deans", companyName: "Atomic", companyPosition: "")
        }
    }
}
