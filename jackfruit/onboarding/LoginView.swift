//
//  LoginView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-21.
//

import SwiftUI
import Combine
import FirebaseAnalytics

final class LoginVM: ObservableObject, Completeable {
    @Published var email = ""
    @Published var password = ""
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    let didComplete = PassthroughSubject<LoginVM, Never>()
    
    init(email: String?, password: String?) {
        self.email = email ?? ""
        self.password = password ?? ""
    }
    
    
    func didTapNext() {
        guard isValid else {
            return
        }
        didComplete.send(self)
    }
}

struct LoginView: View {
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    @AppStorage("user_id") var userId: String = ""
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
