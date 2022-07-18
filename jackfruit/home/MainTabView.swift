//
//  MainTabView.swift
//  jackfruit
//
//  Created by Aryan Mahindra on 6/24/22.
//

import SwiftUI


struct TabItemData {
    let image: String
    let selectedImage: String
    let imageSystem: String
}

struct TabItemView: View {
    let data: TabItemData
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Image(isSelected ? data.selectedImage : data.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .animation(.default)
            
            
            //Spacer().frame(height: 19)
            
            Image(systemName: data.selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .animation(.default)
            Spacer()
            Spacer()
            
    
        }
    }
}

struct TabBottomView: View {
    
    let tabbarItems: [TabItemData]
    var height: CGFloat = 60
    var width: CGFloat = UIScreen.main.bounds.width - 32
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack{
            Text("")
            
            
            HStack {
                Spacer()
                
                ForEach(tabbarItems.indices) { index in
                    let item = tabbarItems[index]
                    Button {
                        self.selectedIndex = index
                    } label: {
                        let isSelected = selectedIndex == index
                        TabItemView(data: item, isSelected: isSelected)
                    }
                    Spacer()
                }
            }
            .frame(width: width, height: height)
            .background(Color.init(UIColor.middleColor))
            
            .cornerRadius(25)
            
            //.shadow(radius: 5, x: 5, y: 10)
        }
        .frame(width: width, height: height)
        
        
        .cornerRadius(19)
        
        //.shadow(radius: 5, x: 5, y: 10)
        }
    
}

struct CustomTabView<Content: View>: View {
    
    let tabs: [TabItemData]
    @Binding var selectedIndex: Int
    @ViewBuilder let content: (Int) -> Content
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(tabs.indices) { index in
                    content(index)
                        .tag(index)
                }
            }
            
            VStack {
                Spacer()
                TabBottomView(tabbarItems: tabs, selectedIndex: $selectedIndex)
            }
            
        }.foregroundColor(.black)
    }
}



enum TabType: Int, CaseIterable {
    case home = 0
    case myFile
    case profile
    
    
    var tabItem: TabItemData {
        switch self {
        case .home:
            return TabItemData(image: "sparkle.magnifyingglass", selectedImage: "sparkle.magnifyingglass", imageSystem: "sparkle.magnifyingglass")
        case .myFile:
            return TabItemData(image: "plus.rectangle", selectedImage: "plus.rectangle", imageSystem: "plus.rectangle")
        case .profile:
            return TabItemData(image: "figure.stand.line.dotted.figure.stand", selectedImage: "figure.stand.line.dotted.figure.stand", imageSystem: "figure.stand.line.dotted.figure.stand")
        }
    }
}

//systemName: "sparkle.magnifyingglass"

//struct MainTabView: View {
//
//    @State var selectedIndex: Int = 0
//    @AppStorage("is_onboarded") var isOnboarded: Bool = false
////    @Binding var userModel: UserModel
//
//    var body: some View {
//        CustomTabView(tabs: TabType.allCases.map({ $0.tabItem }), selectedIndex: $selectedIndex) { index in
//            let type = TabType(rawValue: index) ?? .home
//            getTabView(type: type)
//        }.background(Color.init(UIColor.middleColor))
//    }
//
//    @ViewBuilder
//    func getTabView(type: TabType) -> some View {
//        switch type {
//        case .home:
//            ContactsList()
//        case .myFile:
//            ContactsAdd()
//        case .profile:
//            ContactsDiscover()
//        }
//    }
//}
//
struct MainTabView: View {
    
    @State var selectedIndex: Int = 0
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    //    @Binding var userModel: UserModel
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            ContactsList().tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Contacts").font(Font.custom("CircularStd-Black",
                                                  size: 10))
                }.tag(0)
            ContactsAdd().tabItem {
                Image(systemName: "plus.circle")
                Text("Add Contact").font(Font.custom("CircularStd-Black",
                                                         size: 10))
                }.tag(1)
            ActivitiesPopUp().tabItem {
                Image(systemName: "list.bullet.rectangle.fill")
                Text("Discover").font(Font.custom("CircularStd-Black",
                                                size: 10))
                }.tag(2)
        }.accentColor(Color.init(UIColor.transitionPage))
        
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
    }
}




struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
