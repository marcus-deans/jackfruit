//
//  ContactsList.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore
import WrappingHStack

class Theme {
    static func navigationBarColors(background : UIColor?,
                                    titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor =  .clear
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black, .font : UIFont(name: "CircularStd-Black", size: 35)!]
        
        navigationAppearance.backgroundImage = UIImage(named: "Gradient2")
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "CircularStd-Book", size: 20)!]
        
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
        Theme.navigationBarColors(background: .transitionPage, titleColor: .black)
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.transitionPage]
    }
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if #available(iOS 15.0, *) {
                NavigationView {
                    List {
                        ForEach(searchResults) {
                            userItem in
                            NavigationLink(destination: DetailsView(userItem: userItem)) {
                                HStack{
                                    EmojiCircleView().padding(.vertical, 7)
                                    Text(userItem.firstName!)
                                        .font(Font.custom("CircularStd-Book", size: 20))
                                    + Text(" ")
                                    + Text(userItem.lastName!)
                                        .font(Font.custom("CircularStd-Book",
                                                          size: 20))
                                }
                            }.listRowSeparator(.hidden).padding(.trailing, 20)
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
            VStack(alignment: .center, spacing: 1) {
                //might cause a bug depending on the name size
                LargerProfileView().padding(.bottom, 40)
                HStack{
                    Text(userItem.firstName!)
                        .font(Font.custom("PTSans-Bold", size: 24))
                    + Text(" ")
                        .font(Font.custom("PTSans-Bold", size: 24))
                    + Text(userItem.lastName!)
                        .font(Font.custom("PTSans-Bold", size: 24))
                }.padding(.bottom, 5)
                HStack{
                    Text(userItem.phoneNumber!)
                        .font(Font.custom("PTSans-Bold", size: 16))
                        .fontWeight(.black).bold()
                }
                HStack {
                    Text(userItem.emailAddress!)
                        .font(Font.custom("PTSans-Bold", size: 15))
                        .fontWeight(.black).bold()
                        .underlineTextField()
                    
                    HStack{
                        Text("Currently In ")
                            .font(Font.custom("PTSans-Bold", size: 20))
                            .fontWeight(.black).bold()
                        
                        Text(userItem.location!)
                            .font(Font.custom("PTSans-Bold", size: 15))
                            .fontWeight(.black).bold()
                            .underlineTextField()
                    }
                }
                Text("Interests")
                    .font(Font.custom("PTSans-Bold", size: 20))
                    .fontWeight(.black).bold()
            }
            WrappingHStack {
                ForEach(userItem.parameters!, id : \.self) { child in
                    StoreRow(title: child)
                }
            }
        }
        .padding()
        .navigationBarTitle(Text(userItem.firstName!), displayMode: .inline)
    }
    
}


struct StoreRow: View {
    
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


struct EmojiCircleView: View {
    var body: some View {
        ZStack {
            Text("")
                .shadow(radius: 2)
                .font(.largeTitle)
                .frame(width: 65, height: 35)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 3)
                    
                )
        }
    }
}

struct LargerProfileView: View {
    var body: some View {
        Image("Profilephoto").resizable().frame(width: 350.0, height: 250.0)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init(UIColor.redGradient), lineWidth: 5))
    }
}


struct ContactsMain_Previews: PreviewProvider {
    static var previews: some View {
        ContactsList()
    }
}
