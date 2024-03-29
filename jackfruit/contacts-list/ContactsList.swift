//
//  ContactsList.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAnalytics

class ContactsListVM: ObservableObject {
    //    @Published var users = [UserModel]()
    
    @Published var users: Set<UserModel> = Set()
    @Published var ownUserModel: UserModel = UserModel()
    @AppStorage("user_id") var userId: String = ""
    let settings = FirestoreSettings()
    private var db = Firestore.firestore()
    
    init(){
        settings.isPersistenceEnabled = true
        //TODO: set an appropriate value for this
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
        Task {
            await getOwnUserModel(userId: userId, completion: { ownUserModel in
                self.ownUserModel = ownUserModel
            })
        }
    }
    
    func getOwnUserModel(userId: String, completion: @escaping (UserModel) -> Void) async {
        db.collection("users").document(userId).getDocument(as: UserModel.self){
            result in
            switch result {
            case .success(let model):
                completion(model)
            case .failure(let error):
                print("Could not obtain model, \(error)")
            }
        }
    }

    
    func fetchData(userId: String) {
        //        users = [UserModel]()
        users = Set()
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        db.collection("users").document(userId).addSnapshotListener { (documentSnapshot, error) in
            guard let data = documentSnapshot?.data() else {
                print("No documents")
                return
            }
            
            
            let personalRelationships:[String] = data["personal_contacts"] as? [String] ?? []
            
            personalRelationships.forEach { personalId in
                guard personalId != "" else {
                    print("Personal ID is empty")
                    return
                }
                self.db.collection("users").document(personalId)
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
                        let phoneNumber = data["phone_number"] as? String ?? ""
                        let emailAddress = data["last_name"] as? String ?? ""
                        let location = data["location"] as? String ?? ""
                        let photoURL = data["photo_url"] as? String ?? ""
                        let parameters = data["parameters"] as? [String] ?? []
                        let companyName = data["company_name"] as? String ?? ""
                        let companyPosition = data["company_position"] as? String ?? ""
                        let linkedinURL = data["linkedin_url"] as? String ?? ""
                        let instagramURL = data["instagram_url"] as? String ?? ""
                        let snapchatURL = data["snapchat_url"] as? String ?? ""
                        let githubURL = data["github_url"] as? String ?? ""
                        let twitterURL = data["twitter_url"] as? String ?? ""
                        let hometown = data["hometown"] as? String ?? ""
                        let birthMonth = data["birth_month"] as? String ?? ""
                        let birthNumber = data["birth_number"] as? String ?? ""
                        let universityName = data["university_name"] as? String ?? ""
                        let universityDegree = data["university_degree"] as? String ?? ""
                        //                        self.users.append
                        // MARK: working with onboarded only
                        //                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
                        
                        
                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters, companyName: companyName, companyPosition: companyPosition, linkedinURL: linkedinURL, instagramURL: instagramURL, snapchatURL: snapchatURL, githubURL: githubURL, twitterURL: twitterURL, hometown: hometown, birthMonth: birthMonth, birthNumber: birthNumber, universityName: universityName, universityDegree: universityDegree))
                    }
            }

            
            
            let professionalRelationships:[String] = data["professional_contacts"] as? [String] ?? []
            
            professionalRelationships.forEach { professionalId in
                guard professionalId != "" else {
                    print("Professional ID is empty")
                    return
                }
                self.db.collection("users").document(professionalId)
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
                        let phoneNumber = data["phone_number"] as? String ?? ""
                        let emailAddress = data["last_name"] as? String ?? ""
                        let location = data["location"] as? String ?? ""
                        let photoURL = data["photo_url"] as? String ?? ""
                        let parameters = data["parameters"] as? [String] ?? []
                        let companyName = data["company_name"] as? String ?? ""
                        let companyPosition = data["company_position"] as? String ?? ""
                        let linkedinURL = data["linkedin_url"] as? String ?? ""
                        let githubURL = data["github_url"] as? String ?? ""
                        let hometown = data["hometown"] as? String ?? ""
                        let universityName = data["university_name"] as? String ?? ""
                        let universityDegree = data["university_degree"] as? String ?? ""
                        
                        //                        self.users.append(UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters))
                        // MARK: working with onboarded characteristics only
                        // self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters, companyName: companyName, companyPosition: companyPosition, linkedinURL: linkedinURL, githubURL: githubURL, hometown: hometown, universityName: universityName, universityDegree: universityDegree))
                    }
            }
        }
    }
    
    
    // deleting user based on phone number
    func deleteUser(deletionContactId: String){
        guard userId != "" else {
            print("User ID is empty")
            return
        }
        guard deletionContactId != "" else {
            print("Deleted contact number is empty")
            return
        }
        let currentUserRef = db.collection("users").document(userId)
        currentUserRef.updateData([
            "personal_contacts": FieldValue.arrayRemove([deletionContactId]),
            "professional_contacts": FieldValue.arrayRemove([deletionContactId])
        ]) { err in
            if let err = err {
                print("Error deleting contact: \(err)")
            } else {
                print("Contact \(deletionContactId) successfully deleted")
            }
        }
    }
    
    func fetchAllUsers() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.users = Set(documents.map { queryDocumentSnapshot -> UserModel in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? UUID ?? UUID()
                let firstName = data["first_name"] as? String ?? ""
                let lastName = data["last_name"] as? String ?? ""
                let phoneNumber = data["phone_number"] as? String ?? ""
                let emailAddress = data["last_name"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let photoURL = data["photo_url"] as? String ?? ""
                let parameters = data["parameters"] as? [String] ?? []
                
                return UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters)
            }
            )
        }
    }
}

struct ContactsList: View {
    @StateObject var vm = ContactsListVM()
    
    var body: some View {
        ContactsListView(users: $vm.users,
                         ownUserModel: $vm.ownUserModel,
                         fetchDataAction: { userId in vm.fetchData(userId: userId)},
                         deleteContactAction: { userId in
                            vm.deleteUser(deletionContactId: userId)})
            .onAppear() {
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: "\(ContactsList.self)",
                                            AnalyticsParameterScreenClass: "\(ContactsListVM.self)"])
          }
    }
}
