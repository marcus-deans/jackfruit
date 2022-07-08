//
//  jackfruitApp.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Firebase

@main
struct jackfruitApp: App {
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    @AppStorage("user_id") var userId: String = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var flowVM: FlowVM?

    var body: some Scene {
        WindowGroup {
            if isOnboarded{
                MainTabView()
                    .transition(transition)
                
            } else {
                FlowView(vm: FlowVM())
                    .transition(transition)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        
    }
    
}
