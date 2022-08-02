//
//  UserRepository.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-26.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import Factory
import os

class ContactRepository: ObservableObject {
    // MARK: - Dependencies
    @Injected(Container.myFirestore) var db: Firestore
    @Injected(Container.myAuthRepository) var authRepository
    
    // MARK: - Publishers
    @Published public var contacts = [Contact]()
    @Published public var ownContact = Contact()
    
    // MARK: - Private Attributes
    private var userId: String = "unknown"
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    let logger = Logger(subsystem: "jackfruit", category: "persistence")
    
    init(){
        // observe user ID
        authRepository.$user
          .compactMap { user in
            user?.uid
          }
          .assign(to: \.userId, on: self)
          .store(in: &cancellables)
//
        authRepository.$user
          .receive(on: DispatchQueue.main)
          .sink { [weak self] user in
            if self?.listenerRegistration != nil {
              self?.unsubscribe()
              self?.subscribe()
            }
          }
          .store(in: &cancellables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe(){
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe() {
        if listenerRegistration != nil {
          unsubscribe()
        }
        
        db.collection("users").document(userId).getDocument(as: Contact.self){
            result in
            switch result {
            case .success(let ownmodel):
                self.ownContact = ownmodel
            case .failure(let error):
                print("Could not obtain model, \(error)")
                return
            }
        }
        
        
        let query = db.collection("users")
          .whereField("userId", isEqualTo: userId)
        
        listenerRegistration = query
          .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              self?.logger.debug("No documents in 'users' collection")
              return
            }
            
            self?.contacts = documents.compactMap { queryDocumentSnapshot in
              let result = Result { try queryDocumentSnapshot.data(as: Contact.self) }
              
              switch result {
              case .success(let contactmodel):
                // A `Reminder` value was successfully initialized from the DocumentSnapshot.
                return contactmodel
              case .failure(let error):
                // A `Reminder` value could not be initialized from the DocumentSnapshot.
                switch error {
                case DecodingError.typeMismatch(_, let context):
                  self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
                case DecodingError.valueNotFound(_, let context):
                  self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
                case DecodingError.keyNotFound(_, let context):
                  self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
                case DecodingError.dataCorrupted(let key):
                  self?.logger.error("\(error.localizedDescription): \(key.debugDescription)")
                default:
                  self?.logger.error("Error decoding document: \(error.localizedDescription)")
                }
                return nil
              }
            }
          }
      }
    
    func addContact(_ contact: Contact){
        do {
            let addedContact = contact
            logger.debug("Adding contact '\(addedContact.firstName!)' for user \(self.userId)")
            let _ = try db.collection("contacts").addDocument(from: addedContact)
        }
        catch {
            logger.error("Error: \(error.localizedDescription)")
        }
    }
    
    func updateContact(_ contact: Contact) {
        if let documentId = contact.docId {
          do {
            try db.collection("contacts").document(documentId).setData(from: contact)
          }
          catch {
            self.logger.debug("Unable to update document \(documentId): \(error.localizedDescription)")
          }
        }
      }
      
      func removeContact(_ contact: Contact) {
        if let documentId = contact.docId {
          db.collection("contacts").document(documentId).delete() { error in
            if let error = error {
              self.logger.debug("Unable to remove document \(error.localizedDescription)")
            }
          }
        }
      }
}




//func fetchData(userId: String) {
//    //        users = [UserModel]()
//    users = Set()
//    guard userId != "" else {
//        print("User ID is empty")
//        return
//    }
//    db.collection("users").document(userId).addSnapshotListener { (documentSnapshot, error) in
//        guard let data = documentSnapshot?.data() else {
//            print("No documents")
//            return
//        }
//
//
//        let personalRelationships:[String] = data["personal_contacts"] as? [String] ?? []
//
//        personalRelationships.forEach { personalId in
//            guard personalId != "" else {
//                print("Personal ID is empty")
//                return
//            }
//            self.db.collection("users").document(personalId)
//                .addSnapshotListener { documentSnapshot, error in
//                    guard let document = documentSnapshot else {
//                        print("Error fetching document: \(error!)")
//                        return
//                    }
//                    guard let data = document.data() else {
//                        print("Document data was empty.")
//                        return
//                    }
//                    let id = data["id"] as? UUID ?? UUID()
//                    let firstName = data["first_name"] as? String ?? ""
//                    let lastName = data["last_name"] as? String ?? ""
//                    let phoneNumber = data["phone_number"] as? String ?? ""
//                    let emailAddress = data["last_name"] as? String ?? ""
//                    let location = data["location"] as? String ?? ""
//                    let photoURL = data["photo_url"] as? String ?? ""
//                    let parameters = data["parameters"] as? [String] ?? []
//                    let companyName = data["company_name"] as? String ?? ""
//                    let companyPosition = data["company_position"] as? String ?? ""
//                    let linkedinURL = data["linkedin_url"] as? String ?? ""
//                    let instagramURL = data["instagram_url"] as? String ?? ""
//                    let snapchatURL = data["snapchat_url"] as? String ?? ""
//                    let githubURL = data["github_url"] as? String ?? ""
//                    let twitterURL = data["twitter_url"] as? String ?? ""
//                    let hometown = data["hometown"] as? String ?? ""
//                    let birthMonth = data["birth_month"] as? String ?? ""
//                    let birthNumber = data["birth_number"] as? String ?? ""
//                    let universityName = data["university_name"] as? String ?? ""
//                    let universityDegree = data["university_degree"] as? String ?? ""
//                    //                        self.users.append
//                    // MARK: working with onboarded only
//                    //                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
//
//
//                    self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters, companyName: companyName, companyPosition: companyPosition, linkedinURL: linkedinURL, instagramURL: instagramURL, snapchatURL: snapchatURL, githubURL: githubURL, twitterURL: twitterURL, hometown: hometown, birthMonth: birthMonth, birthNumber: birthNumber, universityName: universityName, universityDegree: universityDegree))
//                }
//        }
//
//
//
//        let professionalRelationships:[String] = data["professional_contacts"] as? [String] ?? []
//
//        professionalRelationships.forEach { professionalId in
//            guard professionalId != "" else {
//                print("Professional ID is empty")
//                return
//            }
//            self.db.collection("users").document(professionalId)
//                .addSnapshotListener { documentSnapshot, error in
//                    guard let document = documentSnapshot else {
//                        print("Error fetching document: \(error!)")
//                        return
//                    }
//                    guard let data = document.data() else {
//                        print("Document data was empty.")
//                        return
//                    }
//                    let id = data["id"] as? UUID ?? UUID()
//                    let firstName = data["first_name"] as? String ?? ""
//                    let lastName = data["last_name"] as? String ?? ""
//                    let phoneNumber = data["phone_number"] as? String ?? ""
//                    let emailAddress = data["last_name"] as? String ?? ""
//                    let location = data["location"] as? String ?? ""
//                    let photoURL = data["photo_url"] as? String ?? ""
//                    let parameters = data["parameters"] as? [String] ?? []
//                    let companyName = data["company_name"] as? String ?? ""
//                    let companyPosition = data["company_position"] as? String ?? ""
//                    let linkedinURL = data["linkedin_url"] as? String ?? ""
//                    let githubURL = data["github_url"] as? String ?? ""
//                    let hometown = data["hometown"] as? String ?? ""
//                    let universityName = data["university_name"] as? String ?? ""
//                    let universityDegree = data["university_degree"] as? String ?? ""
//
//                    //                        self.users.append(UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters))
//                    // MARK: working with onboarded characteristics only
//                    // self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
//                    self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters, companyName: companyName, companyPosition: companyPosition, linkedinURL: linkedinURL, githubURL: githubURL, hometown: hometown, universityName: universityName, universityDegree: universityDegree))
//                }
//        }
//    }
//}

//
//// deleting user based on phone number
//func deleteUser(deletionContactId: String){
//    guard userId != "" else {
//        print("User ID is empty")
//        return
//    }
//    guard deletionContactId != "" else {
//        print("Deleted contact number is empty")
//        return
//    }
//    let currentUserRef = db.collection("users").document(userId)
//    currentUserRef.updateData([
//        "personal_contacts": FieldValue.arrayRemove([deletionContactId]),
//        "professional_contacts": FieldValue.arrayRemove([deletionContactId])
//    ]) { err in
//        if let err = err {
//            print("Error deleting contact: \(err)")
//        } else {
//            print("Contact \(deletionContactId) successfully deleted")
//        }
//    }
//}

//func getOwnUserModel(userId: String, completion: @escaping (UserModel) -> Void) async {
//    db.collection("users").document(userId).getDocument(as: UserModel.self){
//        result in
//        switch result {
//        case .success(let model):
//            completion(model)
//        case .failure(let error):
//            print("Could not obtain model, \(error)")
//        }
//    }
//}
