//
//  ProfileModal.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileModalVM: ObservableObject {
    var showLoginForm: Bool
    @Published var enteredUserName: String
    
    @Published var companyName: String = ""
    @Published var companyPosition: String = ""
    @Published var linkedinURL: String = ""
    @Published var instagramURL: String = ""
    @Published var snapchatURL: String = ""
    @Published var githubURL: String = ""
    @Published var twitterURL: String = ""
    @Published var hometown: String = ""
    @Published var birthMonth: String = ""
    @Published var birthNumber: String = ""
    @Published var universityName: String = ""
    @Published var universityDegree: String = ""
    
    
    @Environment(\.dismiss) var dismiss
    
    private var userModel: UserModel
    var loggedInUser: String?
    let db = Firestore.firestore()

    
    init(userId: String){
        let userRef = db.collection("users").document(userId)
        self.showLoginForm = true
        self.loggedInUser = nil
        self.enteredUserName = ""
        self.userModel = UserModel()
        userRef.getDocument(as: UserModel.self){ result in
            switch result {
            case .success(let model):
                self.userModel = model
            case .failure(let error):
                print("Could not obtain model, \(error.localizedDescription)")
                self.userModel = UserModel()
            }
        }
    }
    
    func updateUserEntry() {
        userModel.companyName = companyName
        
 
        do {
            let _ = try db.collection("users").document(userModel.phoneNumber ?? "0000000000").setData(JSONSerialization.jsonObject(with: JSONConverter.encode(userModel) ?? Data()) as? [String:Any] ?? ["user":"error"] )
        }
        catch {
            print(error)
        }
    }
}

struct ProfileModal: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("user_id") var userId: String = ""
    @StateObject var vm: ProfileModalVM
    
    var body: some View {
        ProfileModalView(
            showLoginForm: vm.showLoginForm,
            enteredUserName: $vm.enteredUserName,
            loggedInUser: vm.loggedInUser)
    }
    
}
