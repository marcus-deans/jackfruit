
//

import SwiftUI
import ToastUI
import FirebaseFirestore
import WrappingHStack

class ActivitiesVM: ObservableObject {
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

struct ActivitiesPopUp: View {

    @ObservedObject var viewModel1 = ActivitiesVM()
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    @State var showingPopup = false // 1
    @State private var presentingToast: Bool = false
    @State var isPresented = false
    
    init(){
        Theme.navigationBarColors(background: .transitionPage, titleColor: .black)
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.transitionPage]
    }
    
    var searchResults: [String: [String]] {
        let userList = viewModel1.users
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
       ZStack{
           Color.init(UIColor.middleColor)         
           VStack{
               let screenWidth = UIScreen.main.bounds.width
               let columns = [GridItem(.flexible()), GridItem(.flexible())]
               ZStack{
                   NavigationView {
                       ScrollView {
                           LazyVGrid(columns: columns, spacing: 10) {
                               ForEach(searchResults.keys.sorted(), id: \.self) { item in
                                   NavigationLink(destination: DetailsViewDiscover1(profiles: searchResults[item]!)) {
                                     
                                       VStack {
                                           Text(item)
                                               .font(Font.custom("CircularStd-Black", size: 20))
                                           Text("9 friends")
                                               .font(Font.custom("CircularStd-Black", size: 15))
                                       }
                                       .frame(width: screenWidth-240, height: 100)
                                       //.padding()
                                       .background(Color.init(UIColor.transitionPage))
                                       .foregroundColor(.white)
                                       .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                   
                                   }
                               }
                           }.padding(.horizontal, 33)
                           .frame(maxHeight: 700)
                       }.padding(.top, 20).navigationBarTitle("Discover").navigationBarHidden(false)}
                }
            }.onAppear() { // (3)
                self.viewModel1.fetchData(userId: userId)
            }
       }
   }
}

struct DetailsViewDiscover1: View {
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


//
//  ActivitiesPopUp.swift
//  jackfruit
//
//  Created by Aditya Bora on 7/17/22.
//


