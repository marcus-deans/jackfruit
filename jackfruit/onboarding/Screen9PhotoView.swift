//
//  Screen9PhotoView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-10.
//

import SwiftUI
import Combine
import os
import FirebaseAnalytics

final class Screen9PhotoVM: ObservableObject, Completeable {
    @Published var profilePhoto:UIImage?
    var phoneNumber = ""
    
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Screen9PhotoVM.self)
    )
    
    let didComplete = PassthroughSubject<Screen9PhotoVM, Never>()
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    var isValid: Bool {
        profilePhoto != nil
    }
    
    
    func didTapNext(image: UIImage)  {
        self.profilePhoto = image
        //do some network calls etc
        didComplete.send(self)
    }
    
    
}


struct Screen9PhotoView: View {
    @StateObject var vm: Screen9PhotoVM
    
    var body: some View {
        Screen9PhotoPure { userImage in
            vm.didTapNext(image: userImage)
        }
        .onAppear() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "\(Screen9PhotoView.self)",
                                       AnalyticsParameterScreenClass: "\(Screen9PhotoVM.self)"])
      }
    }
}
