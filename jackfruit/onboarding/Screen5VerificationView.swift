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
    @State private var editing = false
    @State var progressValue: Float = 0.4
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("user_id") var userId: String = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                 
                    ProgressBar(value: $progressValue).frame(height: 10)
                        
                    Text("Enter your verification code")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        
                    Text("This lets us confirm who you are")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
          
                        
                    TextField("Verification Code", text: $vm.verificationCode, onEditingChanged: { edit in
                                    self.editing = edit
                        }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.oneTimeCode)
                    //TODO: fix the keyboard
                        .keyboardType(.numberPad)
                        .onChange(of: self.vm.verificationCode, perform: {value in
                            if value.count > 6 {
                                self.vm.verificationCode = String(value.prefix(6))
                            }
                        })
                        .focused($focusedField, equals: .verificationCode)
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                     .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
                    self.vm.didTapNext()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .disabled(!vm.isValid)
                .buttonStyle(BlueButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .keyboard){
                    Button("Done"){
                        focusedField = nil
                    }
                }
            }
        }.ignoresSafeArea(.keyboard)
    }
}


