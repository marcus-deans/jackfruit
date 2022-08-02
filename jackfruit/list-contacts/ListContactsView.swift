//
//  ListContactsView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-27.
//

import Foundation

import SwiftUI
import FirebaseAnalytics
import PhoneNumberKit

class Thema {
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

struct ListContactsView: View {
    init(users: Binding<[Contact]>, ownUserModel: Binding<Contact>, fetchDataAction: @escaping (String) -> Void, deleteContactAction: @escaping (Contact) -> Void){
        Thema.navigationBarColors(background: .transitionPage, titleColor: .black)
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.transitionPage]
        self._users = users
        self.fetchDataAction = fetchDataAction
        self._ownUserModel = ownUserModel
        self.deleteContactAction = deleteContactAction
    }
    @State private var searchText = ""
    @AppStorage("user_id") var userId: String = ""
    @State private var showProfileModal = false
    
    @Binding var users: [Contact]
    @Binding var ownUserModel: Contact
    
    let fetchDataAction: (String) -> Void
    let deleteContactAction: (Contact) -> Void
    
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    NavigationLink(destination: RowProfileView(profileModel: ownUserModel)){
                        RowProfileView(profileModel: ownUserModel)
                    }
                    .listRowSeparator(.hidden).padding(.trailing, 20)
//                    .foregroundColor(Color.init(UIColor.transitionPage))
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundColor(.init(UIColor.cardColor))
                        .shadow(radius: 1)
                    )
                    .padding(.top, 1)
                    .listRowBackground(Color.init(UIColor.transitionPage))
                    
                    ForEach(searchResults) {
                        userItem in
                        NavigationLink(destination: RowProfileView(profileModel: userItem)) {
                            RowProfileView(profileModel: userItem)
                        }
                        .listRowSeparator(.hidden).padding(.trailing, 20)
                    }
                    .onDelete(perform: delete)
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
    func delete(at offsets: IndexSet){
        
        print("User delete values")
        for contact in offsets.makeIterator() {
            let contactToDelete = searchResults[contact]
            print(contactToDelete)
//            users.remove(atOffsets: offsets)
//            users.remove(contactToDelete)
            deleteContactAction(contactToDelete)

        }
    }
    
    var searchResults: [Contact] {
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

struct RowProfileView: View {
    let profileModel: Contact
    
    var body: some View {
        HStack{
            ProfilePhotoView(profileURL: profileModel.photoURL!)
                .padding(.vertical, 10)
            VStack(alignment: .leading) {
                HStack {
                    Text(profileModel.firstName!)
                        .font(Font.custom("CircularStd-Black", size: 20))
                    + Text(" ")
                    + Text(profileModel.lastName!)
                        .font(Font.custom("CircularStd-Black", size: 20))
                }
                
                Text(profileModel.phoneNumber!)
                    .font(Font.custom("CircularStd-Black", size: 15))
                    .foregroundColor(Color.init(UIColor.smalltextColor))
                
                HStack{
                    if let companyPosition = profileModel.companyPosition{
                        if companyPosition != "" {
                            Text("\(companyPosition) |")
                                .font(Font.custom("CircularStd-Black", size: 15))
                                .foregroundColor(Color.init(UIColor.smalltextColor))
                        }
                    }
                    
                    if let companyName = profileModel.companyName{
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
}

struct ListContactsView_Previews: PreviewProvider {
    static var previews: some View {
        let userModelOne = (Contact(
            firstName: "Marcus",
            lastName: "Deans",
            emailAddress: "marcusddeans@outlook.com",
            phoneNumber: "9196414032",
            location: "San Francisco",
            photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
            parameters: ["pets", "traveling"],
            companyName: "Atomic",
            companyPosition: "Summer Intern"))
        let userModelTwo = (Contact(
            firstName: "Marcus",
            lastName: "Deans",
            emailAddress: "marcusddeans@outlook.com",
            phoneNumber: "2263151814",
            location: "San Francisco",
            photoURL: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg",
            parameters: ["pets", "traveling"],
            companyName: "Atomic",
            companyPosition: "Summer Intern"))
        ListContactsView(users: .constant([userModelOne, userModelTwo]), ownUserModel: .constant(userModelOne), fetchDataAction: {_ in }, deleteContactAction: {_ in })
    }
}
