
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
    
    var searchResults: [String: [UserModel]] {
        let userList = viewModel1.users
        var paramMap = [String: [UserModel]]()
        for prof in userList {
            for param in prof.parameters! {
                if paramMap[param] != nil {
                    paramMap[param]!.append(prof)
                } else {
                    paramMap[param] = [prof]
                }
            }
        }
        if searchText.isEmpty {
            return paramMap
        } else {
            return paramMap.filter { $0.key.contains(searchText) }
        }
    }
    
    func getNumberOfFriends(activity : [UserModel]) -> Int {
        var count = 0
        for friend in activity {
            count += 1
        }
        return count
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
                                       let count = getNumberOfFriends(activity: searchResults[item]!)
                                       VStack {
                                           Text(item)
                                               .font(Font.custom("CircularStd-Black", size: 20))
                                           Text("\(count) friends")
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
    let profiles: [UserModel]
    var body: some View {
        ZStack {
            //Color.init(UIColor.middleColor)
            if #available(iOS 15.0, *) {
//                Button("Profile") {
//                    showProfileModal.toggle()
//                }
//                .sheet(isPresented: $showProfileModal) {
//                    //                    ProfileModal()
//                }
                NavigationView {
                    List {
                        ForEach(profiles) { userItem in
                            NavigationLink(destination: DetailsView(userItem: userItem).navigationBarHidden(true)) {
                                HStack{
                                    EmojiCircleView().padding(.vertical, 10)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(userItem.firstName!)
                                                .font(Font.custom("CircularStd-Black", size: 20))
                                            + Text(" ")
                                            + Text(userItem.lastName!)
                                                .font(Font.custom("CircularStd-Black",
                                                                  size: 20))
                                        }
                                        
                                        Text(userItem.phoneNumber!)
                                            .font(Font.custom("CircularStd-Black",
                                                              size: 15)).foregroundColor(Color.init(UIColor.smalltextColor))
                                        
                                    }
                                }.foregroundColor(Color.init(UIColor.black))
                            }.listRowSeparator(.hidden).padding(.trailing, 20)
                        }.background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundColor(.init(UIColor.cardColor))
                                .shadow(radius: 1)
                        ).padding(.top, 1)
                            .listRowBackground(Color.init(UIColor.middleColor))
                    }.padding(.top, 5)
                        .listStyle(.plain).background(Color.init(UIColor.middleColor))
                        .navigationBarHidden(true)
                }
            } else {
                // Fallback on earlier versions
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


