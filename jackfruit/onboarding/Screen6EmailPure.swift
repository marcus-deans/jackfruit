//
//  Screen6EmailPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen6EmailPure: View {
    let didTapNextAction: () -> Void
    @Binding var emailAddress:String
    
    @State private var editing = false
    @State var progressValue: Float = 0.64
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
                    
                    
                    TextField("Email", text: $emailAddress, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
                    didTapNextAction()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .buttonStyle(BlueButtonStyle())
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct Screen6EmailPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen6EmailPure(didTapNextAction: {}, emailAddress: .constant("marcusddeans@outlook.com"))
    }
}
