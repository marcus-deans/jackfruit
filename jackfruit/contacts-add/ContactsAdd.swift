//
//  ContactsAdd.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAnalytics
import ToastUI

class ContactsAddVM: ObservableObject {
    let db = Firestore.firestore()
    @Published var contactModel: UserModel = UserModel()
    @Published var groupName: String = ""
    @Published var groupExists: Bool?
    @Published var showContactAddedDialog: Bool = false
    @AppStorage("user_id") var userId: String = ""
    
    func addProfessionalContact(contactNumber: String) {
        guard contactNumber != "" else {
            print("Contact number is empty")
            return
        }
        Task {
            await doAsyncGetUser(contactNumber: contactNumber, completion: { contactModel in
                self.contactModel = contactModel
                self.showContactAddedDialog = true
                self.addProfessionalRelationship(professionalContact: contactNumber)
            })
        }
    }
    
    
    func addProfessionalRelationship(professionalContact: String){
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard professionalContact != "" else {
            print("Work contact number is empty")
            return
        }
        print("user ID is \(userId)")
        let currentUserRef = db.collection("users").document(userId)
        currentUserRef.updateData([
            "professional_contacts": FieldValue.arrayUnion([professionalContact])
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    

    func addGroup(groupId: String){
        // Update one field, creating the document if it does not exist.
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard groupId != "" else {
            print("Group ID is empty")
            return
        }
        let docRef = db.collection("groups").document(groupId)
        docRef.setData([ "members": FieldValue.arrayUnion([userId]) ], merge: true)
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func addPersonalContact(contactNumber: String) {
        guard contactNumber != "" else {
            print("Contact number is empty")
            return
        }
        Task {
            await doAsyncGetUser(contactNumber: contactNumber, completion: { contactModel in
                self.contactModel = contactModel
                self.showContactAddedDialog = true
                self.addPersonalRelationship(personalContact: contactNumber)
            })
        }
    }
    
    func addPersonalRelationship(personalContact: String){
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        print("user ID is \(userId)")
        let currentUserRef = db.collection("users").document(userId)
        currentUserRef.updateData([
            "personal_contacts": FieldValue.arrayUnion([personalContact])
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func doAsyncGetUser(contactNumber: String, completion: @escaping (UserModel) -> Void) async {
        print("Getting user now")
        await db.collection("users").document(contactNumber)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let id = data["id"] as? UUID ?? UUID()
                let firstName = data["first_name"] as? String ?? ""
                let lastName = data["last_name"] as? String ?? ""
                
                let contactModel = UserModel(id: id, firstName: firstName, lastName: lastName)
                print(contactModel)
                completion(contactModel)
            }
    }
    
    func checkGroupExists(groupId: String, completion: @escaping(_ doesExist: Bool)->()){
        // Update one field, creating the document if it does not exist.
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard groupId != "" else {
            print("Group ID is empty")
            return
        }
        let docRef = db.collection("groups").document(groupId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.groupName = document.get("name") as? String ?? ""
                print("Group name: \(self.groupName)")
                completion(true)
//                print("Document data: \(dataDescripti""on)")
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
}

struct ContactsAdd: View {
    @StateObject var viewModel = ContactsAddVM()
    
    
    var body: some View {
        ContactsAddView(
            addWorkContactAction: { enteredNumber in
                viewModel.addProfessionalContact(contactNumber: enteredNumber)
            },
            addGroupContactAction: { enteredNumber in
                print("Executing group with number \(enteredNumber)")
                Task {
//                    viewModel.checkGroupExists(userId: storedUserId, groupId: enteredNumber)
                    viewModel.addGroup(groupId: enteredNumber)
                }
            },
            addFriendContactAction: { enteredNumber in
                viewModel.addPersonalContact(contactNumber: enteredNumber)
            },
            checkGroupExistsAction: { groupNumber in
                print("Checking whether group \(groupNumber) exists")
                var groupDoesExist: Bool = false
                viewModel.checkGroupExists(groupId: groupNumber){ (doesExist) in
                    print("Found that group \(groupNumber) exists? \(doesExist)")
                    groupDoesExist = doesExist
                }
                return groupDoesExist
            },
            contactModel: $viewModel.contactModel,
            groupName: $viewModel.groupName,
            showContactAddedDialog: $viewModel.showContactAddedDialog
        )
        .onAppear() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "\(ContactsAdd.self)",
                                        AnalyticsParameterScreenClass: "\(ContactsAddVM.self)"])
      }
    }
        
    
}
