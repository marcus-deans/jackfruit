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
    

//    @Environment(\.dismiss) var dismiss
    
    @Published var userModel: UserModel
    
    let db = Firestore.firestore()
    
    
    init(userId: String){
        self.userModel = UserModel()
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
                completion(model)
            case .failure(let error):
                print("Could not obtain model, \(error)")
            }
        }
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
