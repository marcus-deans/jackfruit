//
//  Screen8ParametersView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//


import WrappingHStack
import SwiftUI
import Combine
import FirebaseAnalytics

final class Screen8ParametersVM: ObservableObject, Completeable {
    @Published var parameters: [String]
    
    let didComplete = PassthroughSubject<Screen8ParametersVM, Never>()
    let goToRootRequested = PassthroughSubject<Screen8ParametersVM, Never>()
    
    
    init(parameters: [String]?) {
        self.parameters = parameters ?? []
    }
    
    func didTapNext() {
        print("Printing parameters")
        print(parameters)
        //do some network calls etc
        didComplete.send(self)
    }
}

struct Screen8ParametersView: View {
    @StateObject var vm : Screen8ParametersVM
    
    var body: some View {
        Screen8ParametersPure(didTapNextAction: vm.didTapNext, selectedActivities: $vm.parameters)
            .onAppear() {
                Analytics.logEvent(AnalyticsEventScreenView,
                                   parameters: [AnalyticsParameterScreenName: "\(Screen8ParametersView.self)",
                                               AnalyticsParameterScreenClass: "\(Screen8ParametersVM.self)"])
            }
    }
}

struct Screen8ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        Screen8ParametersView(vm: Screen8ParametersVM(parameters: ["traveling", "pets"]))
    }
}
