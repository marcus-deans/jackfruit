//
//  ProfileModal.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI

class ProfileModalVM: ObservableObject {
    let showLoginForm: Bool
    @Published var enteredUserName: String
    @Environment(\.dismiss) var dismiss

    let loggedInUser: String?
    
    init(){
        self.showLoginForm = true
        self.loggedInUser = nil
        self.enteredUserName = ""
    }
    
}

struct ProfileModal: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ProfileModalVM()
    
    var body: some View {
        ProfileModalView(
            showLoginForm: viewModel.showLoginForm,
            enteredUserName: $viewModel.enteredUserName,
            loggedInUser: viewModel.loggedInUser)
    }
    
}

struct ProfileModal_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModal()
    }
}
