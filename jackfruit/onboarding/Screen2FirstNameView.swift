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
        !firstName.isEmpty
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
    @State private var editing = false
    @State var progressValue: Float = 0.16
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("What's your first name?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                    
                    Text("You won't be able to change this later!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                    
                    
                    TextField("First Name", text: $vm.firstName, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.givenName)
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


struct Screen2FirstNameView_Previews : PreviewProvider {
    static var previews: some View {
        Screen2FirstNameView(vm: Screen2FirstNameVM(
            firstName: "Aditya"))
    }
}
