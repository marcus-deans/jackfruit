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
            loggedInUser: nil
        )
        
        ProfileModalView(
            showLoginForm: false,
            enteredUserName: .constant(""),
            loggedInUser: "Mike Mousey"
        )
    }
}
