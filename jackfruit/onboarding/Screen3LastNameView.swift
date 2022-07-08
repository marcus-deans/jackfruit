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
    @State private var editing = false
    @State var progressValue: Float = 0.2
    @State private var keyboardHeight: CGFloat = 0
    
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                 
                    ProgressBar(value: $progressValue).frame(height: 10)
                        
                    Text("What's your last name?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        
                    Text("You won't be able to change this later!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
          
                        
                        TextField("Last Name", text: $vm.lastName, onEditingChanged: { edit in
                                    self.editing = edit
                        }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.familyName)
                        .textInputAutocapitalization(.words)
                    
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
