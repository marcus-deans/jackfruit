//
//  ContactsList.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAnalytics

class Theme {
    static func navigationBarColors(background : UIColor,
                                    titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor =  .white
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font : UIFont(name:"CircularStd-Black", size: 30)!]
        
        //navigationAppearance.backgroundImage = UIImage(named: "Gradient4")
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "CircularStd-Book", size: 20)!]
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

class ContactsListVM: ObservableObject {
    //    @Published var users = [UserModel]()
    
    @Published var users: Set<UserModel> = Set()
    private var db = Firestore.firestore()
    
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
    @ObservedObject var viewModel = ContactsListVM()
    init(){
        Theme.navigationBarColors(background: .transitionPage, titleColor: .black)
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.transitionPage]
    }
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    @State private var showProfileModal = false
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
//            Button("Crash") {
//              fatalError("Crash was triggered")
//            }
            NavigationView {
                List {
                    ForEach(searchResults) {
                        userItem in
                        NavigationLink(destination: ProfileView(userModel: userItem)) {
                            HStack{
                                ProfilePhotoView(profileURL: userItem.photoURL!)
                                    .padding(.vertical, 10)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(userItem.firstName!)
                                            .font(Font.custom("CircularStd-Black", size: 20))
                                        + Text(" ")
                                        + Text(userItem.lastName!)
                                            .font(Font.custom("CircularStd-Black", size: 20))
                                    }
                                    
                                    Text(userItem.phoneNumber!)
                                        .font(Font.custom("CircularStd-Black", size: 15))
                                        .foregroundColor(Color.init(UIColor.smalltextColor))
                                    
                                }
                            }
                            .foregroundColor(Color.init(UIColor.black))
                        }
                        .listRowSeparator(.hidden).padding(.trailing, 20)
                    }
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundColor(.init(UIColor.cardColor))
                        .shadow(radius: 1)
                    )
                    .padding(.top, 1)
                    .listRowBackground(Color.init(UIColor.middleColor))
                }
                .padding(.top, 5)
                .listStyle(.plain).background(Color.init(UIColor.middleColor))
                
                //.padding()
                .onAppear() { // (3)
                    self.viewModel.fetchData(userId: userId)
                    Analytics.logEvent(AnalyticsEventScreenView,
                                       parameters: [AnalyticsParameterScreenName: "\(ContactsList.self)",
                                                   AnalyticsParameterScreenClass: "\(ContactsList.self)"])
                    
                    
                }.navigationBarTitle("Contacts")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            VStack {
                                Spacer().searchable(text: $searchText, placement: .toolbar)
                            }
                            
                            .background(Color.white)
                            .font(Font.custom("CircularStd-Black", size: 18))
                            
                        }
                        
                    }
                    .navigationBarHidden(false)
            }
        }
    }
    var searchResults: [UserModel] {
        let userList = Array(viewModel.users)
        if searchText.isEmpty {
            let sortedUserList = userList.sorted { (user1, user2) -> Bool in
                let user1firstName = user1.firstName ?? ""
                let user2firstName = user2.firstName ?? ""
                return (user1firstName.localizedCaseInsensitiveCompare(user2firstName) == .orderedAscending)
            }
            return sortedUserList
        } else {
            return userList.filter { $0.firstName!.contains(searchText) }
        }
    }
}

struct ContactsList_Previews: PreviewProvider {
    static var previews: some View {
        ContactsList()
    }
}
