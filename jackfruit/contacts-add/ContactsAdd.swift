//
//  ContactsAdd.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore

class ContactsAddVM: ObservableObject {
    let db = Firestore.firestore()
    
    func addPersonalRelationship(userId: String, personalContact: String){
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard personalContact != "" else {
            print("Personal contact number is empty")
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
    
    func addProfessionalRelationship(userId: String, professionalContact: String){
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
    
    func addGroup(userId: String, groupId: String){
        // Update one field, creating the document if it does not exist.
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard groupId != "" else {
            print("Group ID is empty")
            return
        }
        print("user ID is \(userId)")
        db.collection("groups").document(groupId).setData([ "members": FieldValue.arrayUnion([userId]) ], merge: true)
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct ContactsAdd: View {
    @StateObject var viewModel = ContactsAddVM()
    
    @AppStorage("user_id") var storedUserId: String = ""
    
    var body: some View {
        ContactsAddView(
            addWorkContactAction: { enteredNumber in
                print("Executing professional with number \(enteredNumber)")
                viewModel.addProfessionalRelationship(userId: storedUserId, professionalContact: enteredNumber)
            },
            addGroupContactAction: { enteredNumber in
                print("Executing group with number \(enteredNumber)")
                viewModel.addGroup(userId: storedUserId, groupId: enteredNumber)
            },
            addFriendContactAction: { enteredNumber in
                print("Executing personal with number \(enteredNumber)")
                viewModel.addPersonalRelationship(userId: storedUserId, personalContact: enteredNumber)
            }
        )
    }
    
}
