//
//  Screen6EmailView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

//
//  Screen5EmailView.swift
//  contacts-frontend
//
//  Created by Marcus Deans on 2022-07-03.
//

import SwiftUI
import Combine

final class Screen6EmailVM: ObservableObject, Completeable {
    @Published var emailAddress = ""
    
    let didComplete = PassthroughSubject<Screen6EmailVM, Never>()
    let skipRequested = PassthroughSubject<Screen6EmailVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !emailAddress.isEmpty
    }
    
    init(email: String?) {
        self.emailAddress = email ?? ""
    }
    
    
    func didTapNext() {
        //do some network calls etc
        guard isValid else {
            return
        }
        //do some network calls etc
        didComplete.send(self)
    }
    
    fileprivate func didTapSkip() {
        skipRequested.send(self)
    }
}

struct Screen6EmailView: View {
    @StateObject var vm: Screen6EmailVM
    
    var body: some View {
        Screen6EmailPure(didTapNextAction: vm.didTapNext, emailAddress: $vm.emailAddress)
    }
}

