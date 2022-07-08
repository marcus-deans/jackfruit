//
//  Screen4NumberView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen4NumberVM: ObservableObject, Completeable {
    @Published var phoneNumber = ""
    
    let didComplete = PassthroughSubject<Screen4NumberVM, Never>()
    let skipRequested = PassthroughSubject<Screen4NumberVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !phoneNumber.isEmpty
    }
    
    init(phoneNumber: String?) {
        self.phoneNumber = phoneNumber ?? ""
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

// ProfessionalParameters (for reference)
//var experienceYears: String?
//var companyTitle: String?
//var companyPosition: String?
//var professional: Bool?
//var backend: Bool?
//var frontend: Bool?
//var cloud: Bool?
struct Screen4NumberView: View {
    @StateObject var vm: Screen4NumberVM
    @State private var editing = false
    @State var progressValue: Float = 0.4
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("user_id") var userId: String = ""

    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                 
                    ProgressBar(value: $progressValue).frame(height: 10)
                        
                    Text("What's your   phone number?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        
                    Text("We'll use this to link to your contacts")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
          
                        
                    TextField("Phone Number", text: $vm.phoneNumber, onEditingChanged: { edit in
                                    self.editing = edit
                        }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.telephoneNumber)
                    //TODO: fix the keyboard
                        .keyboardType(.namePhonePad)
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                     .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
                    userId = vm.phoneNumber
                    self.vm.didTapNext()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .disabled(!vm.isValid)
                .buttonStyle(BlueButtonStyle())
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }.ignoresSafeArea(.keyboard)
    }
}
