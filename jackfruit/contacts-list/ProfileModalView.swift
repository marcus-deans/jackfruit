//
//  ProfileModalView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI


struct ProfileModalView: View {
    
    let showLoginForm: Bool
    @Binding var enteredUserName: String
    @Environment(\.dismiss) var dismiss
    
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
        VStack {
            if showLoginForm {
                TextField("Username", text: $enteredUserName)
                //                Button("Login", action: loginAction)
            }
            if let username = loggedInUser {
                Text("Greetings, \(username)")
            }
            Button("Press to dismiss") {
                dismiss()
            }
            .font(.title)
            .padding()
            .background(.black)
        }
    }
    
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(
            showLoginForm: true,
            enteredUserName: .constant(""),
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
