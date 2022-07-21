//
//  ContactsListView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI
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

struct ContactsListView: View {
    init(users: Binding<Set<UserModel>>, fetchDataAction: @escaping (String) -> Void){
        Theme.navigationBarColors(background: .transitionPage, titleColor: .black)
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        self._users = users
        self.fetchDataAction = fetchDataAction
    }
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    @State private var showProfileModal = false
    
    @Binding var users: Set<UserModel>
    
    let fetchDataAction: (String) -> Void
    
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
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
                    //                    self.viewModel.fetchData(userId: userId)
                    fetchDataAction(userId)
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
        let userList = Array(users)
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

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        let userModelOne = (UserModel(
            firstName: "Marcus",
            lastName: "Deans",
            emailAddress: "marcusddeans@outlook.com",
            phoneNumber: "9196414032",
            location: "San Francisco",
            photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
            parameters: ["pets", "traveling"],
            companyName: "Atomic",
            companyPosition: "Summer Intern"))
        let userModelTwo = (UserModel(
            firstName: "Marcus",
            lastName: "Deans",
            emailAddress: "marcusddeans@outlook.com",
            phoneNumber: "2263151814",
            location: "San Francisco",
            photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
            parameters: ["pets", "traveling"],
            companyName: "Atomic",
            companyPosition: "Summer Intern"))
        ContactsListView(users: .constant(Set([userModelOne, userModelTwo])), fetchDataAction: {_ in })
    }
}
