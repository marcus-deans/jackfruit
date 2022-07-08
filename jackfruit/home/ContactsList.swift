//
//  ContactsList.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore

class Theme {
    static func navigationBarColors(background : UIColor?,
                                    titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

class ContactsListVM: ObservableObject {
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

struct ContactsList: View {
    @ObservedObject var viewModel = ContactsListVM()
    
    init(){
        Theme.navigationBarColors(background: .white, titleColor: .black)
    }
    
    //    private let userList: [UserModel] = [
    //        UserModel(
    //            firstName: "Marcus", lastName: "Deans", emailAddress: "marcusddeans@outlook.com", phoneNumber: "9196414032", location: "San Francisco", parameters: ["cloud","backend","conservative"]
    //            ),
    //        UserModel(firstName: "Aditya", lastName: "Bora", emailAddress: "adibora@gmail.com", phoneNumber: "1234567890", location: "Palo Alto", parameters: ["tennis","backend","packers"]
    //            ),
    //        UserModel(firstName: "Aryan", lastName: "Mohindra", emailAddress: "amohindra@hotmail.com", phoneNumber: "0987654321", location: "Miami", parameters: ["android","tennis","incubator"]
    //            )
    //    ]
    
    
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                List {
                    ForEach(searchResults) {
                        userItem in
                        NavigationLink(destination: DetailsView(userItem: userItem)) {
                            HStack{
                                //                                EmojiCircleView(emojiItem: emojiItem)
                                Text(userItem.firstName!)
                                    .font(Font.custom("PTSans-Bold", size: 15))
                                Text(userItem.lastName!)
                                    .font(Font.custom("PTSans-Bold",
                                                      size: 15))
                            }
                            
                        }
                    }
                    
                }
                .searchable(text: $searchText).padding()
                .onAppear() { // (3)
                    self.viewModel.fetchData(userId: userId)
                }
                
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    var searchResults: [UserModel] {
        let userList = viewModel.users
        if searchText.isEmpty {
            return userList
        } else {
            return userList.filter { $0.firstName!.contains(searchText) }
        }
    }
}


struct DetailsView: View {
    
    let userItem: UserModel
    var body: some View {
        
        VStack() {
            VStack(alignment: .leading, spacing: 1) {
                //might cause a bug depending on the name size
                HStack{
                    //                        EmojiCircleView(emojiItem: emojiItem)
                    Text(userItem.firstName!)
                        .font(Font.custom("PTSans-Bold", size: 22))
                    
                }
                HStack{
                    Text("Phone Number:")
                        .font(Font.custom("PTSans-Bold", size: 20))
                        .fontWeight(.black).bold()
                    
                    Text(userItem.phoneNumber!)
                        .font(Font.custom("PTSans-Bold", size: 20))
                        .fontWeight(.black).bold()
                        .underlineTextField()
                }
                HStack{
                    Text("Email:")
                        .font(Font.custom("PTSans-Bold", size: 20))
                        .fontWeight(.black).bold()
                    
                    Text(userItem.emailAddress!)
                        .font(Font.custom("PTSans-Bold", size: 15))
                        .fontWeight(.black).bold()
                        .underlineTextField()
                }
                HStack{
                    Text("Location:")
                        .font(Font.custom("PTSans-Bold", size: 20))
                        .fontWeight(.black).bold()
                    
                    Text(userItem.location!)
                        .font(Font.custom("PTSans-Bold", size: 15))
                        .fontWeight(.black).bold()
                        .underlineTextField()
                }
            }
            
            VStack(alignment: .center) {
                
                
                List {
                    Section(header: Text("Parameters")) {
                        ForEach(userItem.parameters!, id : \.self) { child in
                            Text(child)
                                .font(Font.custom("PTSans-Bold", size: 20))
                                .fontWeight(.black).bold()
                        }
                    }
                }
                
                // Need a function which creates Professional Facts
                
            }
            
            
        }
        .padding()
        .navigationBarTitle(Text(userItem.firstName!), displayMode: .inline)
    }
    
}


struct EmojiCircleView: View {
    let emojiItem: EmojiItem
    var body: some View {
        ZStack {
            Text(emojiItem.emoji)
                .shadow(radius: 3)
                .font(.largeTitle)
                .frame(width: 65, height: 45)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 3)
                )
        }
    }
}



struct EmojiItem: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let description: String
    let phoneNunber : String
}

struct ContactsMain_Previews: PreviewProvider {
    static var previews: some View {
        ContactsList()
    }
}


