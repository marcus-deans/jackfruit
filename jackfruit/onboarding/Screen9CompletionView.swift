//
//  Screen9CompletionView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine
import Firebase

final class Screen9CompletionVM: ObservableObject, Completeable {
    let name: String
    
    let didComplete = PassthroughSubject<Screen9CompletionVM, Never>()
    
    init(name: String?) {
        self.name = name ?? ""
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}

struct Screen9CompletionView: View {
    @StateObject var vm: Screen9CompletionVM
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    
    var body: some View {

        ZStack {
            Color.init(UIColor.transitionPage).ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Welcome to the app, \(vm.name)")  .font(Font.custom("PTSans-Bold", size: 34))
                    .fontWeight(.black).bold()
        
                Button(action: {
                    withAnimation(.spring()){
                        self.vm.didTapNext()
                        isOnboarded=true
                    }
                }, label: { Text("Next") }).buttonStyle(RoundedRectangleButtonStyle())
            }.padding()
        }
    }
}
