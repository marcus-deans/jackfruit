//
//  Screen3LastNameView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen3LastNameVM: ObservableObject {
    @Published var lastName = ""
    
    let didComplete = PassthroughSubject<Screen3LastNameVM, Never>()
    let skipRequested = PassthroughSubject<Screen3LastNameVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !lastName.isEmpty
    }
    
    init(lastName: String?) {
        self.lastName = lastName ?? ""
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

struct Screen3LastNameView: View {
    @StateObject var vm: Screen3LastNameVM
    
    var body: some View{
        Screen3LastNamePure(didTapNextAction: vm.didTapNext, lastName: $vm.lastName)
    }
}
