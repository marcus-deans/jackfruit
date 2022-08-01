//
//  jackfruitApp.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//
// testing git 

import SwiftUI
import Firebase
import FirebaseAppCheck
import FirebaseAuth

let transition: AnyTransition = .asymmetric(insertion: .move(edge: .bottom),
    removal: .move(edge: .top))

@main
struct jackfruitApp: App {
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    @AppStorage("user_id") var userId: String = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var flowVM: FlowVM?

    var body: some Scene {
        let _ = print("Current root user ID is \(userId)")
        WindowGroup {
            if isOnboarded && Auth.auth().currentUser != nil {
                MainTabView()
                    .transition(transition)
                
            } else {
                FlowView(vm: FlowVM())
                    .transition(transition)
            }
        }
    }
}

class JackfruitAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
#if targetEnvironment(simulator)
    // App Attest is not available on simulators.
    // Use a debug provider.
    let provider = AppCheckDebugProvider(app: app)

    // Print only locally generated token to avoid a valid token leak on CI.
    print("Firebase App Check debug token: \(provider?.localDebugToken() ?? "" )")

    return provider
#else
    // Use App Attest provider on real devices.
    return AppAttestProvider(app: app)
#endif
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //MARK: Firebase App Check
        let providerFactory = JackfruitAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        //MARK: Firebase Cloud Messaging
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions,
//          completionHandler: { _, _ in }
//        )
//        application.registerForRemoteNotifications()


        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        return true
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        
    }
    
}
