//
//  ProfileModalView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI
import NukeUI
import Awesome

struct ProfileModalView: View {
    let updateButtonAction: () -> Void
    //    let onBuildAction: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @State var editing = false
    @Binding var userModel: UserModel
    
    var body: some View {
        ScrollView {
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
                                .fill(.gray)
                                .frame(width: 300, height: 300)
                            
                            Text(userModel.firstName!.prefix(1)+" "+userModel.lastName!.prefix(1))
                                .font(Font.custom("CircularStd-Book", size: 30))
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                }
                .overlay(TextOverlay(firstName: userModel.firstName!, lastName: userModel.lastName!, companyName: userModel.companyName ?? "", companyPosition: userModel.companyPosition ?? ""), alignment: .bottomTrailing)
                
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
                            
                        }.padding(.vertical, 15)
                        
                        VStack{
                            Text("Your Interests").font(Font.custom("CircularStd-Black", size: 20))
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
                                                Text(textEmojiMap[item] ?? item)
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
                    }
                    VStack {
                        Text("Professional").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        HStack {
                            Awesome.Solid.building.image
                                .size(25)
                            TextField("Company Name", text: $userModel.companyName ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .textContentType(.organizationName)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            TextField("Company Position", text: $userModel.companyPosition ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .textContentType(.jobTitle)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        HStack {
                            Awesome.Brand.linkedin.image
                                .size(25)
                            TextField("Linkedin Handle (no @ sign!)", text: $userModel.linkedinURL ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        
                        HStack{
                            Awesome.Brand.github.image
                                .size(25)
                            TextField("Github Handle (no @ sign!)", text: $userModel.githubURL ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font
                                    .custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                    }.padding()
                    
                    VStack {
                        Text("Social Networking").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        HStack{
                            Awesome.Brand.instagram.image
                                .size(25)
                            TextField("Instagram Handle (no @ sign!)", text: $userModel.instagramURL ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        
                        HStack{
                            Awesome.Brand.snapchat.image
                                .size(25)
                            TextField("Snapchat Handle (no @ sign!)", text: $userModel.snapchatURL ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        HStack{
                            Awesome.Brand.twitter.image
                                .size(25)
                            TextField("Twitter Handle (no @ sign!)", text: $userModel.twitterURL ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                    }.padding()
                    
                    VStack{
                        Text("Personal").font(Font.custom("CircularStd-Black", size: 16))
                            .foregroundColor(.black)
                        HStack{
                            Awesome.Solid.home.image
                                .size(25)
                            TextField("Hometown", text: $userModel.hometown ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        
                        HStack{
                            Awesome.Solid.graduationCap.image
                                .size(25)
                            TextField("University Name", text: $userModel.universityName ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            TextField("University Degree", text: $userModel.universityDegree ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                        
                        HStack{
                            Awesome.Solid.birthdayCake.image
                                .size(25)
                            TextField("Birth Month", text: $userModel.birthMonth ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            TextField("Birth Day", text: $userModel.birthNumber ?? "", onEditingChanged: {edit in self.editing = edit })
                                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                    }.padding()
                    
                    
                    HStack{
                        Button("Update Profile"){
                            updateButtonAction()
                            dismiss()
                        }
                        .padding()
                        .buttonStyle(RoundedRectangleButtonStyle())
                        
//                        Button("Cancel") {
//                            dismiss()
//                        }
//                        .padding()
//                        .buttonStyle(RoundedRectangleButtonStyle())
                    }
                }
            }.background(Color.init(UIColor.middleColor)).padding()
        }.background(Color.init(UIColor.middleColor))
        
    }
    
    struct ProfileModalView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileModalView(
                updateButtonAction:{},
                userModel: .constant(UserModel(
                    firstName: "Marcus",
                    lastName: "Deans",
                    emailAddress: "marcusddeans@outlook.com",
                    phoneNumber: "9196414032",
                    location: "San Francisco",
                    photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
                    parameters: ["pets", "traveling"],
                    companyName: "Atomic",
                    companyPosition: "Summer Intern"))
                //            updateButtonAction: {},
                //            companyName: .constant(""),
                //            companyPosition: .constant(""),
                //            linkedinURL: .constant(""),
                //            instagramURL: .constant(""),
                //            snapchatURL: .constant(""),
                //            githubURL: .constant(""),
                //            twitterURL: .constant(""),
                //            hometown: .constant(""),
                //            birthMonth: .constant(""),
                //            birthNumber: .constant(""),
                //            universityName: .constant(""),
                //            universityDegree: .constant(""),
                //            loggedInUser: nil
            )
        }
    }
}
