//
//  Screen7LocationView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen7LocationVM: ObservableObject, Completeable {
    @Published var location = ""
    
    let didComplete = PassthroughSubject<Screen7LocationVM, Never>()
    let skipRequested = PassthroughSubject<Screen7LocationVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !location.isEmpty
    }
    
    init(location: String?) {
        self.location = location ?? ""
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


struct Screen7LocationView: View {
    @StateObject var vm: Screen7LocationVM
    var body: some View {
        Screen7LocationPure(didTapNextAction: vm.didTapNext, location: $vm.location)
    }
}

