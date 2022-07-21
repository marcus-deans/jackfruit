//
//  Screen2FirstNameView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//


import SwiftUI
import Combine


final class Screen2FirstNameVM: ObservableObject, Completeable {
    @Published var firstName = ""
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        return !firstName.isEmpty
    }
    
    let didComplete = PassthroughSubject<Screen2FirstNameVM, Never>()
    
    init(firstName: String?) {
        self.firstName = firstName ?? ""
    }
    
    
    func didTapNext() {
        guard isValid else {
            return
        }
        didComplete.send(self)
    }
}


struct Screen2FirstNameView: View {
    @StateObject var vm: Screen2FirstNameVM
    
    var body: some View {
        Screen2FirstNamePure(didTapNextAction: vm.didTapNext, firstName: $vm.firstName)
    }
}
