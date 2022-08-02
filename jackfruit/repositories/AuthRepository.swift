//
//  AuthRepository.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-26.
//

import Foundation
import FirebaseAuth
import os
import Factory

public class AuthRepository: ObservableObject{
    private let logger = Logger(subsystem: "jackfruit", category: "auth")
    
    @Published public var user: User?
    @Published var verificationId:String = ""
    
    func getPhoneVerificationCode(phoneNumber: String){
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+1\(phoneNumber)", uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
                self.verificationId = verificationID!
            }
    }
    
    func authenticatePhoneUser(verificationCode: String){
        print("Verification Code is \(verificationCode)")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                return
            }
            
            // User has signed in successfully and currentUser object is valid
            self.user = Auth.auth().currentUser
        }
    }
    
    func loginWithEmail(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                return
            }
            // User has signed in successfully and currentUser object is valid
            let currentUserInstance = Auth.auth().currentUser
            print("Signed in user's email is: \(currentUserInstance?.email)")
            return
        }
    }
}
