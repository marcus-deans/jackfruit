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
    @State private var editing = false
    @State var progressValue: Float = 0.6
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                 
                    ProgressBar(value: $progressValue).frame(height: 10)
                        
                    Text("What's your email?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        
                    Text("When you share your contact this will automatically be shared!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
          
                        
                    TextField("Email", text: $vm.emailAddress, onEditingChanged: { edit in
                                    self.editing = edit
                        }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                    
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
        }.ignoresSafeArea(.keyboard)
    }
}

