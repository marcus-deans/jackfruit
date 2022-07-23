
//

import SwiftUI
import ToastUI
import FirebaseFirestore
import WrappingHStack


class ActivitiesVM: ObservableObject {
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
                        
                        //                        self.users.append
                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
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
                        
                        //                        self.users.append(UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, parameters: parameters))
                        self.users.update(with: UserModel(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumber: phoneNumber, location: location, photoURL: photoURL, parameters: parameters))
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

struct ActivityItem: Identifiable {
     var id = UUID()
     var activ : String
     var count: Int
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
    
    func sortActivities() -> Array<ActivityItem> {
        
        var activtiesWithCount : [ActivityItem] = []
        // create the list of the all things
        for activity in searchResults.keys.sorted() {
            let freq = getNumberOfFriends(activity: searchResults[activity]!)
            activtiesWithCount.append(ActivityItem(activ : activity, count : freq))
        }
        
        activtiesWithCount.sort { $0.count > $1.count }
        print("ListOfShit" , activtiesWithCount)
        return activtiesWithCount
    }
    
    
    var body: some View {
             
                
        
                ZStack {
                    let screenWidth = UIScreen.main.bounds.width
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    
                    
                    NavigationView {
                        ScrollView {
                            VStack{
                                LazyVGrid(columns: columns, spacing: 10) {
                                    
//                                    ForEach(searchResults.keys.sorted(), id: \.self)  { item in
//                                        NavigationLink(destination: DetailsViewDiscover1(profiles: searchResults[item]!, activity: item)) {
                                            
                                        //    let count = getNumberOfFriends(activity: searchResults[item]!)
                                            
                                            let sortedList = sortActivities()
//                                            let sortedArray = activtiesWithCount.sort { ($0[0] as? Int) < ($1[0] as? Int) }
                                            ForEach(sortedList) { item in
                                                NavigationLink(destination: DetailsViewDiscover1(profiles: searchResults[item.activ]!, activity: item.activ)) {
                                                    VStack {
                                                        Text(item.activ)
                                                            .font(Font.custom("CircularStd-Black", size: 20))
                                                        Text("\(item.count) friends")
                                                            .font(Font.custom("CircularStd-Black", size: 15))
                                                    }
                                                    .frame(width: screenWidth-240, height: 100)
                                                    //.padding()
                                                    .background(Color.init(UIColor.transitionPage))
                                                    .foregroundColor(.white)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                                    }
                                            }
                                   //     }
                                    //}
                                }.padding(.horizontal, 33).padding(.vertical, 20)
                                   // .frame(maxHeight: 700)
                            }.background(Color.init(UIColor.middleColor))
                        
                            .navigationBarTitle("Discover")
                            .navigationBarHidden(false)
                        }.background(Color.init(UIColor.middleColor))
                    }.foregroundColor(Color.init(UIColor.middleColor))
                        
                
            }.onAppear() { // (3)
                self.viewModel1.fetchData(userId: userId)
            }
    }
}

struct DetailsViewDiscover1: View {
    let profiles: [UserModel]
    let activity: String
    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {        
                NavigationView {
                    List {
                        ForEach(profiles) { userItem in
                            NavigationLink(destination: ProfileView(userModel: userItem).navigationBarHidden(true)) {
                                HStack{
                                    ProfilePhotoView(profileURL: userItem.photoURL!)
                                        .padding(.vertical, 10)
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
                                        
                                        
                                        HStack{
                                            if let companyPosition = userItem.companyPosition{
                                                if companyPosition != "" {
                                                    Text("\(companyPosition) |")
                                                        .font(Font.custom("CircularStd-Black", size: 15))
                                                        .foregroundColor(Color.init(UIColor.smalltextColor))
                                                }
                                            }
                                            
                                            if let companyName = userItem.companyName{
                                                if companyName != "" {
                                                    Text(companyName)
                                                        .font(Font.custom("CircularStd-Black", size: 15))
                                                        .foregroundColor(Color.init(UIColor.smalltextColor))
                                                }
                                            }
                                            
                                        }
                                        
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
                }.navigationBarTitle("\(activity)")
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


