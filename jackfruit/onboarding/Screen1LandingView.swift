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
            LinearGradient(gradient: Gradient(colors: [Color.init(UIColor.topGradient), Color.init(UIColor.transitionPage)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Contact")
                    .font(Font.custom("CircularStd-Black", size: 50))
                    .foregroundColor(.white)
                    .padding(.top, 200)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.0, height: 150.0)
                    .padding(.bottom, 190)
                
                Button(action: {
                    self.vm.didTapNext()
                }, label: { Text("Create Account") }).buttonStyle(RoundedRectangleButtonStyle())
            }.navigationBarHidden(true)                        
        }
    }
}

struct Screen1LandingView_Previews : PreviewProvider {
    static var previews: some View {
        Screen1LandingView(vm: Screen1LandingVM())
    }
}




