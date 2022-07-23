//
//  ProfileModal.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAnalytics
import FirebaseStorage
import os

class ProfileModalVM: ObservableObject {
    

//    @Environment(\.dismiss) var dismiss
    
    @Published var userModel: UserModel
    @AppStorage("user_id") var userId: String = ""
    
    let db = Firestore.firestore()
    var photoURL: String = ""
    let storage = Storage.storage()
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ProfileModal.self)
    )

    init(userId: String){
        self.userModel = UserModel()
        Task {
            await doAsyncStuff(userId: userId)
        }
    }
    
    func refreshUserModel(userId: String){
        Task {
            await doAsyncStuff(userId: userId)
        }
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
                print("Got user model. Values are: ")
                print(model)
                completion(model)
            case .failure(let error):
                print("Could not obtain model, \(error)")
            }
        }
    }
    
    func updateUserEntry(){
        do {
            print("Uploading user model. Values are: ")
            print("User is is ")
            print(self.userModel)
            let _ = try db.collection("users").document(self.userModel.phoneNumber ?? "0000000000").setData(JSONSerialization.jsonObject(with: JSONConverter.encode(self.userModel) ?? Data()) as? [String:Any] ?? ["user":"error"] )
        }
        catch {
            print(error)
        }
    }
    
    
    func updateProfileAndModel(image: UIImage){
        Task {
            await doAsyncStuff(image: image)
        }
    }
    
    func doAsyncStuff(image: UIImage) async {
        await addProfileToStorage(image: image){ profilePhoto in
            self.photoURL = profilePhoto
            print("Have obtained profile photo URL: \(profilePhoto)")
            self.updateUserPhotoURL(photoURL: self.photoURL)
        }
    }
    
    func addProfileToStorage(image: UIImage, completion: @escaping (String) -> Void) async {
        guard let imageData = image.jpegData(compressionQuality: 0.15) else {
            logger.log("Error in getting profile image data")
            return
        }
        let storageRef = storage.reference()
        let storageUserRef = storageRef.child("users").child("\(userId).jpg")
        var photoURL:String = ""
        storageUserRef.putData(imageData, metadata: nil){ (metadata, error) in
            guard metadata != nil else {
                print(error?.localizedDescription ?? "No image data")
                return
            }
            
            storageUserRef.downloadURL{ (url, error) in
                guard let downloadURL = url else {
                    print(error?.localizedDescription ?? "Could not obtain URL")
                    return
                }
                photoURL = downloadURL.absoluteString
                completion(photoURL)
            }
        }
        
    }
    
    func updateUserPhotoURL(photoURL: String) {
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "photo_url": photoURL
        ]){ err in
            if let err = err {
                print("Error updating photo URL: \(err)")
            } else {
                print("Document successfully updated with photo URL")
            }
        }
    }
    
    
}

struct ProfileModal: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("user_id") var userId: String = ""
    @StateObject var vm: ProfileModalVM
    
    var body: some View {
        ProfileModalView(updateButtonAction: vm.updateUserEntry, updatePhotoAction: {photoImage in vm.updateProfileAndModel(image: photoImage) },
            userModel: $vm.userModel)
            .onAppear() {
                vm.refreshUserModel(userId: userId)
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: "\(ProfileModal.self)",
                                            AnalyticsParameterScreenClass: "\(ProfileModalVM.self)"])
          }
    }
}
