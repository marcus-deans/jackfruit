//
//  Screen5VerificationView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen5VerificationVM: ObservableObject, Completeable {
    @Published var verificationCode = ""
    
    let characterLimit: Int = 6
    var verificationID = ""
    
    let didComplete = PassthroughSubject<Screen5VerificationVM, Never>()
    let skipRequested = PassthroughSubject<Screen5VerificationVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !verificationCode.isEmpty
    }
    
    init(verificationID: String?) {
        self.verificationID = verificationID ?? ""
        //        self.phoneNumber = phoneNumber ?? ""
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

struct Screen5VerificationView: View {
    @StateObject var vm: Screen5VerificationVM
    
    var body: some View{
        Screen5VerificationPure(didTapNextAction: vm.didTapNext, verificationCode: $vm.verificationCode)
    }
}


