//
//  Screen10CompletionPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen10CompletionPure: View {
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    @State var firstName:String
    let didTapNextAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage).ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Welcome to the app, \(firstName)")  .font(Font.custom("CircularStd-Black", size: 34))
                    .foregroundColor(.white)
                    .fontWeight(.black).bold()
                
                Button(action: {
                    withAnimation(.spring()){
                        didTapNextAction()
                        isOnboarded=true
                    }
                }, label: { Text("Next") }).buttonStyle(RoundedRectangleButtonStyle())
            }.padding()
        }
    }
}

struct Screen10CompletionPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen10CompletionPure(firstName: "Marcus", didTapNextAction: {})
    }
}
