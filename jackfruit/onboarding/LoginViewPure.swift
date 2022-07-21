//
//  Screen2FirstNamePure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct LoginViewPure: View {
    let didTapNextAction: () -> Void
    
    @State private var editing = false
    @State var progressValue: Float = 0.125
    @State private var keyboardHeight: CGFloat = 0
    
    @Binding var email:String
    @Binding var password:String
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .center) {
                    
                    
                    Text("Login")
                        .padding(.top, 200)
                        .foregroundColor(.white)
                        .font(Font.custom("CircularStd-Black", size: 60))
                        .padding(.bottom, 20)
                        
                        
                    
                    TextField("Username", text: $email, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 15)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                    
                    TextField("Password", text: $password, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 50)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.password)
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
                }, label: { Text("Login").font(Font.custom("CircularStd-Book", size: 22)).frame(width:300) })
                //.padding(.leading, 250)
                
                .padding(.bottom, 40)
                .buttonStyle(LoginButtonStyle())
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct LoginViewPure_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewPure(didTapNextAction: {}, email: .constant("Marcus"), password: .constant("Adi"))
    }
}
