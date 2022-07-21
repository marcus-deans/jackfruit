//
//  Screen9CompletionView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAnalytics

final class Screen10CompletionVM: ObservableObject, Completeable {
    let name: String
    
    let didComplete = PassthroughSubject<Screen10CompletionVM, Never>()
    
    init(name: String?) {
        self.name = name ?? ""
        Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: [
          AnalyticsParameterItemName: "end",
        ])
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}

struct Screen10CompletionView: View {
    @StateObject var vm: Screen10CompletionVM
    var body: some View {
        Screen10CompletionPure(firstName: vm.name, didTapNextAction: vm.didTapNext)
            .onAppear() {
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: "\(Screen10CompletionView.self)",
                                           AnalyticsParameterScreenClass: "\(Screen10CompletionVM.self)"])
          }
    }
        
}
