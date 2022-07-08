//
//  Screen1LandingView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine

final class Screen1LandingVM: ObservableObject, Completeable {
    
    let didComplete = PassthroughSubject<Screen1LandingVM, Never>()

    init() {
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}




struct Screen1LandingView: View {
    @StateObject var vm: Screen1LandingVM

    var body: some View {
        ZStack {
            //.background(Color.init(UIColor.afterStartPageTransition))
            Color.init(UIColor.transitionPage).ignoresSafeArea()
            
            VStack(alignment: .center) {
                Image("relationship")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.0, height: 150.0)
                    .padding()
                
                Text("Welcome to Contact")
                    .font(Font.custom("PTSans-Regular", size: 34))
                    .fontWeight(.black).bold()
                
                Button(action: {
                   self.vm.didTapNext()
                }, label: { Text("Next") }).buttonStyle(RoundedRectangleButtonStyle())
            }
            .padding()
        }
    }
}



