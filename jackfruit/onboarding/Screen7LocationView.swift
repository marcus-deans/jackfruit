//
//  Screen7LocationView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen7LocationVM: ObservableObject, Completeable {
    @Published var location = ""
    
    let didComplete = PassthroughSubject<Screen7LocationVM, Never>()
    let skipRequested = PassthroughSubject<Screen7LocationVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !location.isEmpty
    }
    
    init(location: String?) {
        self.location = location ?? ""
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


struct Screen7LocationView: View {
    @StateObject var vm: Screen7LocationVM
    @State private var editing = false
    @State var progressValue: Float = 0.4
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                 
                    ProgressBar(value: $progressValue).frame(height: 10)
                        
                    Text("What's your location?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        
                    Text("You won't be able to change this later!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
          
                        
                    TextField("Location", text: $vm.location, onEditingChanged: { edit in
                                    self.editing = edit
                        }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.addressCity)
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

//struct Screen6LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        Screen6LocationView()
//    }
//}

