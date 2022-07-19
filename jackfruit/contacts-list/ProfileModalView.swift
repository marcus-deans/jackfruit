//
//  ProfileModalView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI


struct ProfileModalView: View {
    let updateButtonAction: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @State var editing = false
    
    @Binding var companyName: String
    @Binding var companyPosition: String
    @Binding var linkedinURL: String
    @Binding var instagramURL: String
    @Binding var snapchatURL: String
    @Binding var githubURL: String
    @Binding var twitterURL: String
    @Binding var hometown: String
    @Binding var birthMonth: String
    @Binding var birthNumber: String
    @Binding var universityName: String
    @Binding var universityDegree: String
    
    let loggedInUser: String?
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("Company Name", text: $companyName, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                    .textContentType(.organizationName)
                
                TextField("Company Position", text: $companyPosition, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                    .textContentType(.jobTitle)
            }
            
            TextField("Linkedin URL", text: $linkedinURL, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            
            TextField("Instagram URL", text: $instagramURL, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            
            TextField("Snapchat URL", text: $snapchatURL, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            
            TextField("Github URL", text: $githubURL, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font
                    .custom("CircularStd-Book", size: 14))
            
            TextField("Twitter URL", text: $twitterURL, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            
            TextField("Hometown", text: $hometown, onEditingChanged: {edit in self.editing = edit })
                .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            
            HStack{
                
                TextField("University Name", text: $universityName, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                
                TextField("University Degree", text: $universityDegree, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            }
            HStack {
                TextField("Birth Month", text: $birthMonth, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
                
                TextField("Birth Day", text: $birthNumber, onEditingChanged: {edit in self.editing = edit })
                    .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 14))
            }
            
            HStack{
            Button("Update Profile"){
                updateButtonAction()
            }
            .padding()
            .font(.title2)
            .background(.green)
            
            Button("Dismiss") {
                dismiss()
            }
            .font(.title2)
            .padding()
            .background(.black)
            }
        }.background(Color.init(UIColor.middleColor))
    }
    
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(
            updateButtonAction: {},
            companyName: .constant(""),
            companyPosition: .constant(""),
            linkedinURL: .constant(""),
            instagramURL: .constant(""),
            snapchatURL: .constant(""),
            githubURL: .constant(""),
            twitterURL: .constant(""),
            hometown: .constant(""),
            birthMonth: .constant(""),
            birthNumber: .constant(""),
            universityName: .constant(""),
            universityDegree: .constant(""),
            loggedInUser: nil
        )
    }
}
