//
//  ContactsList.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore
import WrappingHStack


class ContactsDiscVM: ObservableObject {
    @Published var users = [UserModel]()
    
    private var db = Firestore.firestore()
    
    func fetchData(userId: String) {
        users = [UserModel]()
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
                        let parameters = data["parameters"] as? [String] ?? []
                        
                        self.users.append(UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters))
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
                        let parameters = data["parameters"] as? [String] ?? []
                        
                        self.users.append(UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters))
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
            
            self.users = documents.map { queryDocumentSnapshot -> UserModel in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? UUID ?? UUID()
                let firstName = data["first_name"] as? String ?? ""
                let lastName = data["last_name"] as? String ?? ""
                let phoneNumber = data["phone_number"] as? String ?? ""
                let emailAddress = data["last_name"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let parameters = data["parameters"] as? [String] ?? []
                
                return UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters)
            }
        }
    }
}


struct ContactsDiscover: View {
    @ObservedObject var viewModel = ContactsDiscVM()
    
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
    
    
    var searchResults: [String: [String]] {
        let userList = viewModel.users
        var paramMap = [String: [String]]()
        for prof in userList {
            for param in prof.parameters! {
                if paramMap[param] != nil {
                    paramMap[param]!.append(prof.firstName!)
                } else {
                    paramMap[param] = [prof.firstName!]
                }
            }
        }
        if searchText.isEmpty {
            return paramMap
        } else {
            return paramMap.filter { $0.key.contains(searchText) }
        }
    }
    
    var body: some View {
        
        
        
        ZStack {
            Color.white.ignoresSafeArea()
            if #available(iOS 15.0, *) {
                NavigationView {
                    List {
                        ForEach(searchResults.keys.sorted(), id: \.self) { key in
                            NavigationLink(destination: DetailsViewDiscover(profiles: searchResults[key]!)) {
                                HStack{
                                    EmojiCircleView().padding(.vertical, 7)
                                    Text(key)
                                        .font(Font.custom("CircularStd-Book", size: 20))
                                }                          
                            }
                        }.background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .foregroundColor(.init(UIColor.white))
                                .shadow(radius: 3)
                        )
                        .listRowBackground(Color.white)
                    }.listStyle(.plain).background(Color.white)
                        .searchable(text: $searchText, placement: .automatic)
                    //.padding()
                        .onAppear() { // (3)
                            self.viewModel.fetchData(userId: userId)
                        }                        .navigationBarTitle("Contacts",  displayMode: .inline).navigationBarHidden(false)
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }

}


struct DetailsViewDiscover: View {
    let profiles: [String]
    var body: some View {
        VStack() {
            VStack(alignment: .center, spacing: 1) {
                ForEach(profiles, id: \.self) { profile in
                    Text(profile).font(Font.custom("CircularStd-Book", size: 20))
                }
            }
      
        }
    }
}


struct StoreRow1: View {
    var title: String
    var body: some View {
        ZStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.init(UIColor.transitionPage) , .init(UIColor.redGradient)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        ).frame(height: 40).padding(.horizontal, 5)
                    
                    VStack {
                        Text("\(title)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                }
            }
        }
    }
}





struct ContactsMain_Previews1: PreviewProvider {
    static var previews: some View {
        ContactsList()
    }
}
