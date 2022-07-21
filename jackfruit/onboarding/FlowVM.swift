//
//  FlowVM.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import os

protocol Completeable {
    var didComplete: PassthroughSubject<Self, Never> { get }
}

class FlowVM: ObservableObject {
    
    // Note the final model is manually "bound" to the view models here.
    // Automatic binding would be possible with combine or even a single VM.
    // However this may not scale well
    // and the views become dependant on something that is external to the view.
    private var model: UserModel
    var subscription = Set<AnyCancellable>()
    var verificationID = ""
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FlowVM.self)
    )
    
    @Published var navigateTo1: Bool = true
    @Published var navigateTo2: Bool = false
    @Published var navigateTo3: Bool = false
    @Published var navigateTo4: Bool = false
    @Published var navigateTo5: Bool = false
    @Published var navigateTo6: Bool = false
    @Published var navigateTo7: Bool = false
    @Published var navigateTo8: Bool = false
    @Published var navigateTo9: Bool = false
    @Published var navigateTo10: Bool = false
    @Published var navigateToHome: Bool = false
    @Published var navigateToFinalFrom3: Bool = false
    @Published var navigateToFinalFrom4: Bool = false
    @Published var navigateToLogin: Bool = false
    
    init() {
        self.model = UserModel()
        UINavigationBar.appearance().tintColor = .black
    }
    
    func makeLoginView() -> LoginVM {
        let vm = LoginVM(
            email: "",
            password: ""
        )
        vm.didComplete
            .sink(receiveValue: didCompleteLogin)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen1LandingView() -> Screen1LandingVM {
        let vm = Screen1LandingVM()
        vm.didComplete
            .sink(receiveValue: didComplete1)
            .store(in: &subscription)
        vm.didSelectLogin
            .sink(receiveValue: didSelectLogin)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen2StandardView() -> Screen2FirstNameVM {
        let vm = Screen2FirstNameVM(
            firstName: model.firstName
        )
        vm.didComplete
            .sink(receiveValue: didComplete2)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen3DetailsView() -> Screen3LastNameVM {
        let vm = Screen3LastNameVM(
            lastName: model.lastName
        )
        vm.didComplete
            .sink(receiveValue: didComplete3)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen4NumberView() -> Screen4NumberVM {
        let vm = Screen4NumberVM(
            phoneNumber: model.phoneNumber
        )
        vm.didComplete
            .sink(receiveValue: didComplete4)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen5VerificationView() -> Screen5VerificationVM{
        let vm = Screen5VerificationVM(
            verificationID: self.verificationID
        )
        vm.didComplete
            .sink(receiveValue: didComplete5)
            .store(in: &subscription)
        return vm
    }
    
    
    func makeScreen6EmailView() -> Screen6EmailVM {
        let vm = Screen6EmailVM(
            email: model.emailAddress
        )
        vm.didComplete
            .sink(receiveValue: didComplete6)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen7LocationView() -> Screen7LocationVM {
        let vm = Screen7LocationVM(
            location: model.location
        )
        vm.didComplete
            .sink(receiveValue: didComplete7)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen8ParametersView() -> Screen8ParametersVM {
        let vm = Screen8ParametersVM(
            parameters: model.parameters
        )
        vm.didComplete
            .sink(receiveValue: didComplete8)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen9PhotoView() -> Screen9PhotoVM {
        let vm = Screen9PhotoVM(
            phoneNumber: model.phoneNumber ?? "5555555555"
        )
        vm.didComplete
            .sink(receiveValue: didComplete9)
            .store(in: &subscription)
        return vm
    }
    
    func makeScreen10CompletionView() -> Screen10CompletionVM {
        let vm = Screen10CompletionVM(name: model.firstName)
        vm.didComplete
            .sink(receiveValue: didComplete10)
            .store(in: &subscription)
        return vm
    }
    
    func didSelectLogin(vm: Screen1LandingVM){
        navigateToLogin = true
        navigateTo2 = false
    }
    
    func didComplete1(vm: Screen1LandingVM) {
        // Additional logic inc. updating model
        navigateTo2 = true
    }
    
    func didCompleteLogin(vm: LoginVM){
        let email = vm.email
        let password = vm.password
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                return
            }
            @AppStorage("is_onboarded") var isOnboarded: Bool = false
            @AppStorage("user_id") var userId: String = ""

            // User has signed in successfully and currentUser object is valid
            let currentUserInstance = Auth.auth().currentUser
            print("User has signed in successfully wiht id: \(userId)")
            print("Signed in user's email is: \(currentUserInstance?.email)")
            isOnboarded = true
            return
        }
    }
    
    func didComplete2(vm: Screen2FirstNameVM) {
        // Additional logic
        model.firstName = vm.firstName
        navigateTo3 = true
    }
    
    func didComplete3(vm: Screen3LastNameVM) {
        // Additional logic inc. updating model
        model.lastName = vm.lastName
        navigateTo4 = true
    }
    
    
    func didComplete4(vm: Screen4NumberVM) {
        model.phoneNumber = vm.phoneNumber
        // Additional logic inc. updating model
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+1\(vm.phoneNumber)", uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
                self.verificationID = verificationID!
            }
        navigateTo5 = true
    }
    
    func didComplete5(vm: Screen5VerificationVM){
        print("Verification Code is \(vm.verificationCode)")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: vm.verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                return
            }
            
            // User has signed in successfully and currentUser object is valid
            let currentUserInstance = Auth.auth().currentUser
            self.navigateTo6 = true
        }
    }
    
    func didComplete6(vm: Screen6EmailVM) {
        model.emailAddress = vm.emailAddress
        navigateTo7 = true
    }
    
    func didComplete7(vm: Screen7LocationVM){
        model.location = vm.location
        navigateTo8 = true
    }
    
    func didComplete8(vm: Screen8ParametersVM){
        model.parameters = vm.parameters
        navigateTo9 = true
    }
    
    func didComplete9(vm: Screen9PhotoVM) {
        let image = vm.profilePhoto!
        let phoneNumber = model.phoneNumber
        Task {
            await doAsyncStuff(image: image, phoneNumber: phoneNumber!)
        }
        navigateTo10 = true
    }
    
    func doAsyncStuff(image: UIImage, phoneNumber: String) async {
        await addProfileToStorage(image: image, phoneNumber: phoneNumber){ profilePhoto in
            self.model.photoURL = profilePhoto
            self.updateUserModel()
        }
    }
    
    func addProfileToStorage(image: UIImage, phoneNumber: String, completion: @escaping (String) -> Void) async {
        guard let imageData = image.jpegData(compressionQuality: 0.15) else {
            logger.log("Error in getting profile image data")
            return
        }
        let storageRef = storage.reference()
        let storageUserRef = storageRef.child("users").child("\(phoneNumber).jpg")
        var photoURL:String = ""
        storageUserRef.putData(imageData, metadata: nil){ (metadata, error) in
            guard metadata != nil else {
                print(error?.localizedDescription ?? "No image data")
                return
            }
            
            storageUserRef.downloadURL{ (url, error) in
                guard let downloadURL = url else {
                    print(error?.localizedDescription ?? "Could not obtain URL")
                    return
                }
                photoURL = downloadURL.absoluteString
                completion(photoURL)
            }
        }
        
    }
    
    
    func didComplete10(vm: Screen10CompletionVM) {
        navigateTo2 = false
    }
    
    func updateUserModel() {
        do {
            let _ = try db.collection("users").document(model.phoneNumber ?? "0000000000").setData(JSONSerialization.jsonObject(with: JSONConverter.encode(model) ?? Data()) as? [String:Any] ?? ["user":"error"] )
        }
        catch {
            print(error)
        }
    }
}
