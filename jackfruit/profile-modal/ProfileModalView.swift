//
//  ProfileModalView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI
import NukeUI
import Awesome
import WrappingHStack

struct ProfileModalView: View {
    let updateButtonAction: () -> Void
    //    let onBuildAction: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @State var pickerSelectedImage: UIImage? = nil
    @State var editing = false
    @State var imagePickerSelected = false
    @State var selectedNewImage = false
    @Binding var userModel: UserModel
    @State var showPopUp: Bool = true
    
    
    
    
    var body: some View {
        if(showPopUp) {
            ParamSelection(selectedActivities: .constant([]))
        }
        if(showPopUp == false){
            ScrollView {
                VStack {
                    let photoURL = userModel.photoURL ?? ""
                    LazyImage(source: URL(string: photoURL)) { state in
                        if let newImage = pickerSelectedImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .frame(width: 300, height: 300, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.init(UIColor.yellow), lineWidth: 10))
                                .padding(.top, 20)
                        }
                        else if let image = state.image {
                            image
                                .frame(width: 300, height: 300, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.init(UIColor.transitionPage), lineWidth: 10))
                                .padding(.top, 20)
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
                    .onTapGesture {
                        imagePickerSelected.toggle()
    //                    pickerSelectedImage = true
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
                                
                                TextField("Company Position", text: $userModel.companyPosition ?? "", onEditingChanged: {edit in self.editing = edit })
                                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                    .textContentType(.jobTitle)
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
                            }
                            
                            HStack{
                                Awesome.Solid.graduationCap.image
                                    .size(25)
                                TextField("University Name", text: $userModel.universityName ?? "", onEditingChanged: {edit in self.editing = edit })
                                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                  
                                TextField("University Degree", text: $userModel.universityDegree ?? "", onEditingChanged: {edit in self.editing = edit })
                                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                    .disableAutocorrection(true)
                            }
                            
                            HStack{
                                Awesome.Solid.birthdayCake.image
                                    .size(25)
                                TextField("Birth Month", text: $userModel.birthMonth ?? "", onEditingChanged: {edit in self.editing = edit })
                                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                                
                                TextField("Birth Day", text: $userModel.birthNumber ?? "", onEditingChanged: {edit in self.editing = edit })
                                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                            }
                        }.padding()
                        
                        
                        HStack{
                            Button("Save Changes"){
                                updateButtonAction()
                                dismiss()
                            }
                            .padding()
                            .buttonStyle(LoginButtonStyle())
                        }
                    }
                }.background(Color.init(UIColor.middleColor)).padding()
                
                .sheet(isPresented: $imagePickerSelected){
                    ImagePicker(image: $pickerSelectedImage, showPicker: $imagePickerSelected)
                        .ignoresSafeArea(.keyboard)
                }
            }.background(Color.init(UIColor.middleColor))
        }
        
       

        
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
            )
        }
    }
    
    
    struct PopUpWindow: View {
        var title: String
        var message: String
        var buttonText: String
        @Binding var show: Bool
        var body: some View {
            ZStack {
                if show {
                    // PopUp background color
                    Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text(title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 23, weight: .semibold))
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                            .foregroundColor(Color.white)
                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text(buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
                                .font(Font.system(size: 23, weight: .semibold))
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: 300)
                    .border(Color.white, width: 2)
                    .background(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
                }
            }
        }
    }
    
    
    struct ParamSelection: View {
        
        let columns = [
            GridItem(.flexible())
             
               
               
        ]
        
        @State var progressValue: Float = 0.875
        @State private var editing = false
        
        @State var sportsActivities: [String] = Sports
        @State var artsActivities: [String] = Art
        @State var outdoorActivities: [String] = Outdoors
        @State var entertainmentActivities: [String] = Entertainment
        @State var musicActivities: [String] = Music
        @State var foodActivities: [String] = Food
        @State var funActivities: [String] = Fun
        @State var profInterests: [String] = ProfessionalInterests
        @State var miscInterests: [String] = Misc
        @State var learningActivities: [String] = Learning
        
        @Binding var selectedActivities: [String]
        
        @State var isSelected: Bool = false
        @State var isSelected1: Bool = false

        @State var isSelected2: Bool = false

        @State var isSelected3: Bool = false

        @State var isSelected4: Bool = false
        
        
        
        @State var selection = Set<String>()

        
        let activityLimit = 8
        
        let elements = ["Cat 🐱", "Dog 🐶", "Sun 🌞", "Moon 🌕", "Tree 🌳"]
        
        var body: some View {
            
            ZStack {
                Color.init(UIColor.lighttransition)
                    .ignoresSafeArea()
                ScrollView {
                    
                        VStack(alignment: .leading) {
                            
                       
                            
                            Text("What 8 things best define you?")
                                .font(Font.custom("CircularStd-Black", size: 40))
                                .padding(.bottom, 20)
                                .foregroundColor(.black)
                            
                            Text("When you share your contact this information will be shared too!")
                                .font(Font.custom("CircularStd-Book", size: 20))
                                .foregroundColor(.black)
                            
                        }.padding(.horizontal, 20).padding(.top, 50)
                          //  .fixedSize(horizontal: false, vertical: true)
                            
                
                    
                        
                    
                    
                    LazyVStack(alignment: .leading) {
                        Text("Outdoors").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                            WrappingHStack(outdoorActivities, id: \.self){ activity in
                               // var isSelected : Bool = self.selectedActivities.contains(activity)
                                Button(action: {
                                    
                                    if selection.contains(activity) {
                                        selection.remove(activity)
                                    } else {
                                        selection.insert(activity)
                                    }
                                    
                                }, label: {Text(activity)})
                        //        .frame(width: 50, height: 40)
                        //        .padding(.horizontal, 15)
                                .frame(height: 35, alignment: .center)
                                .padding(.horizontal, 15)
                                .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                .cornerRadius(20)
                                .foregroundColor(.black)
                                .font(Font.custom("CircularStd-Book", size: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                )
                                .padding(.bottom, 10)
                                .padding(.horizontal, 4)
                            }
                    
                            Text("Sports").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                            
                            WrappingHStack(sportsActivities, id: \.self){ activity in
                                
                                
                                Button(action: {
                                    
                                    
                                    if selection.contains(activity) {
                                        selection.remove(activity)
                                    } else {
                                        selection.insert(activity)
                                    }
                                    
                                    
                                    
                                }, label: {Text(activity)})
                        //        .frame(width: 50, height: 40)
                        //        .padding(.horizontal, 15)
                                .frame(height: 35, alignment: .center)
                                .padding(.horizontal, 15)
                                .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                .cornerRadius(20)
                                .foregroundColor(.black)
                                .font(Font.custom("CircularStd-Book", size: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                )
                                .padding(.bottom, 10)
                                .padding(.horizontal, 4)
                            }
                       
                            
                            Group {
                                Text("Music").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                WrappingHStack(musicActivities, id: \.self){ activity in
                                    
                                    Button(action: {
                                        
                                        if selection.contains(activity) {
                                            selection.remove(activity)
                                        } else {
                                            selection.insert(activity)
                                        }
                                        
                                    }, label: {Text(activity)})
                            //        .frame(width: 50, height: 40)
                            //        .padding(.horizontal, 15)
                                    .frame(height: 35, alignment: .center)
                                    .padding(.horizontal, 15)
                                    .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                                    .font(Font.custom("CircularStd-Book", size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                    )
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 4)
                                }
                          
                                Text("Food").font(Font.custom("CircularStd-Book", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                WrappingHStack(foodActivities, id: \.self){ activity in
                                    
                                    Button(action: {
                                        
                                        if selection.contains(activity) {
                                            selection.remove(activity)
                                        } else {
                                            selection.insert(activity)
                                        }
                                        
                                    }, label: {Text(activity)})
                            //        .frame(width: 50, height: 40)
                            //        .padding(.horizontal, 15)
                                    .frame(height: 35, alignment: .center)
                                    .padding(.horizontal, 15)
                                    .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                                    .font(Font.custom("CircularStd-Book", size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                    )
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 4)
                                    
                                }
                                
                        
                                Text("Arts").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                WrappingHStack(artsActivities, id: \.self){ activity in
                                    
                                    
                                    Button(action: {
                                        
                                        if selection.contains(activity) {
                                            selection.remove(activity)
                                        } else {
                                            selection.insert(activity)
                                        }
                                        
                                    }, label: {Text(activity)})
                            //        .frame(width: 50, height: 40)
                            //        .padding(.horizontal, 15)
                                    .frame(height: 35, alignment: .center)
                                    .padding(.horizontal, 15)
                                    .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                                    .font(Font.custom("CircularStd-Book", size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                    )
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 4)
                                    
                                }
                         
                                Text("Fun").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                WrappingHStack(funActivities, id: \.self){ activity in
                                    Button(action: {
                                        
                                        if selection.contains(activity) {
                                            selection.remove(activity)
                                        } else {
                                            selection.insert(activity)
                                        }
                                        
                                    }, label: {Text(activity)})
                            //        .frame(width: 50, height: 40)
                            //        .padding(.horizontal, 15)
                                    .frame(height: 35, alignment: .center)
                                    .padding(.horizontal, 15)
                                    .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                                    .font(Font.custom("CircularStd-Book", size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                    )
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 4)
                                    
                                    }
                            }
                            Group {
                                    Text("Academic").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                    WrappingHStack(profInterests, id: \.self){ activity in
                                        Button(action: {
                                            
                                            if selection.contains(activity) {
                                                selection.remove(activity)
                                            } else {
                                                selection.insert(activity)
                                            }
                                            
                                            
                                        }, label: {Text(activity)})
                                //        .frame(width: 50, height: 40)
                                //        .padding(.horizontal, 15)
                                        .frame(height: 35, alignment: .center)
                                        .padding(.horizontal, 15)
                                        .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                        .cornerRadius(20)
                                        .foregroundColor(.black)
                                        .font(Font.custom("CircularStd-Book", size: 18))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                        )
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 4)                            }
                              
                                    Text("Miscellaneous").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                    WrappingHStack(miscInterests, id: \.self){ activity in
                                        Button(action: {
                                            
                                            if selection.contains(activity) {
                                                selection.remove(activity)
                                            } else {
                                                selection.insert(activity)
                                            }
                                            
                                        }, label: {Text(activity)})
                                //        .frame(width: 50, height: 40)
                                //        .padding(.horizontal, 15)
                                        .frame(height: 35, alignment: .center)
                                        .padding(.horizontal, 15)
                                        .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                        .cornerRadius(20)
                                        .foregroundColor(.black)
                                        .font(Font.custom("CircularStd-Book", size: 18))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                        )
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 4)
                                    }
                                
                            
                                Text("Education").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                                WrappingHStack(learningActivities, id: \.self){ activity in
                                    Button(action: {
                                        
                                        if selection.contains(activity) {
                                            selection.remove(activity)
                                        } else {
                                            selection.insert(activity)
                                        }
                                    }, label: {Text(activity)})
                            //        .frame(width: 50, height: 40)
                            //        .padding(.horizontal, 15)
                                    .frame(height: 35, alignment: .center)
                                    .padding(.horizontal, 15)
                                    .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                                    .font(Font.custom("CircularStd-Book", size: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                    )
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 4)
                                    
                                }
                            }
                            Text("Entertainment").font(Font.custom("CircularStd-Black", size: 25)).foregroundColor(.black).padding(.leading, 4).multilineTextAlignment(.leading)
                            WrappingHStack(entertainmentActivities, id: \.self){ activity in
                                Button(action: {
                                    
                                    if selection.contains(activity) {
                                        selection.remove(activity)
                                    } else {
                                        selection.insert(activity)
                                    }
                                    
                                }, label: {Text(activity)})
                        //        .frame(width: 50, height: 40)
                        //        .padding(.horizontal, 15)
                                .frame(height: 35, alignment: .center)
                                .padding(.horizontal, 15)
                                .background(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
                                .cornerRadius(20)
                                .foregroundColor(.black)
                                .font(Font.custom("CircularStd-Book", size: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selection.contains(activity) ? Color.init(UIColor.yellow) : Color.black)
                                )
                                .padding(.bottom, 10)
                                .padding(.horizontal, 4)                            }
                        
                    
                        Button(action: {
                            
                        }, label: { Text(">") })


                        .padding(.leading, 20)
                        .padding(.bottom, 40)
                        .buttonStyle(BlueButtonStyle())
                    
                    }
                       
                        
                        
                    .padding(.horizontal, 20)
                    
                }
            }
            
         
        }
    }
}

