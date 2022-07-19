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
            Color.init(UIColor.white).ignoresSafeArea()
            
            VStack(alignment: .center) {
                
                
                Text("Welcome to Contact")
                    .font(Font.custom("CircularStd-Black", size: 34))
                    .fontWeight(.black).bold()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.0, height: 150.0)
                    .padding(.bottom, 90)
                
                Button(action: {
                    self.vm.didTapNext()
                }, label: { Text("Create Contact") }).buttonStyle(RoundedRectangleButtonStyle())
            }.navigationBarHidden(true)
            .padding()
        }
    }
}

struct Screen1LandingView_Previews : PreviewProvider {
    static var previews: some View {
        Screen1LandingView(vm: Screen1LandingVM())
    }
}




