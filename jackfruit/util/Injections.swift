//
//  Injections.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-26.
//

import Foundation
import Factory
import Firebase

extension Container {
    static let myFirestore = Factory { Firestore.firestore().enableLogging(on: true) as Firestore }
    static let myContactRepository = Factory { ContactRepository() as ContactRepository}
    static let myAuthRepository = Factory { AuthRepository() as AuthRepository }
}

extension Firestore {
    func enableLogging(on: Bool = true) -> Firestore {
        Self.enableLogging(on)
        return self
    }
}
