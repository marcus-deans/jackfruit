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
    
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var emailAddress: String = ""
    var location: String = ""
    var photoURL: String = ""
    var parameters: [String] = []
    
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
    
    
//    @Environment(\.dismiss) var dismiss
    
    @Published var userModel: UserModel
    
    let db = Firestore.firestore()
    
    
    init(userId: String){
//        let userRef = db.collection("users").document(userId)
        self.userModel = UserModel()
        Task {
            await doAsyncStuff(userId: userId)
        }
//        self.userModel = UserModel()
        //        userRef.getDocument(){ (document, error) in
        //            let result = Result {
        //                try document.flatMap {
        //                    try $0.data(as: UserModel.self)
        //                }
        //            }
        //        }
//        userRef.getDocument(as: UserModel.self){ result in
//            switch result {
//            case .success(let model):
//                self.userModel = model
//            case .failure(let error):
//                print("Could not obtain model, \(error.localizedDescription)")
//                self.userModel = UserModel()
//            }
//        }
    }
    
    func doAsyncStuff(userId: String) async{
        await getUserModel(userId: userId, completion: { userModel in
            self.userModel = userModel
        })
    }
    
    func getUserModel(userId: String, completion: @escaping (UserModel) -> Void) async {
        await db.collection("users").document(userId).getDocument(as: UserModel.self){
            result in
            switch result {
            case .success(let model):
                completion(model)
            case .failure(let error):
                print("Could not obtain model, \(error)")
            }
        }
    }
    
    func getCurrentValues(){
        firstName = userModel.firstName ?? ""
        lastName = userModel.lastName ?? ""
        phoneNumber = userModel.phoneNumber ?? ""
        emailAddress = userModel.emailAddress ?? ""
        location = userModel.location ?? ""
        photoURL = userModel.photoURL ?? ""
        parameters = userModel.parameters ?? []
        
        companyName = userModel.companyName ?? ""
        companyPosition = userModel.companyPosition ?? ""
        linkedinURL = userModel.linkedinURL ?? ""
        instagramURL = userModel.instagramURL ?? ""
        snapchatURL = userModel.snapchatURL ?? ""
        githubURL = userModel.githubURL ?? ""
        twitterURL = userModel.twitterURL ?? ""
        hometown = userModel.hometown ?? ""
        birthMonth = userModel.birthMonth ?? ""
        birthNumber = userModel.birthNumber ?? ""
        universityName = userModel.universityName ?? ""
        universityDegree = userModel.universityDegree ?? ""
    }
    
    func updateUserEntry(){
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
        ProfileModalView(updateButtonAction: vm.updateUserEntry, userModel: $vm.userModel)
    }
}
