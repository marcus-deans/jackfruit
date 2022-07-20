//
//  Screen5VerificationPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen5VerificationPure: View {
    let didTapNextAction: () -> Void
    
    @State private var editing = false
    @State var progressValue: Float = 0.4
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("user_id") var userId: String = ""
    @FocusState private var focusedField: Field?
    
    @Binding var verificationCode:String
    @State var isValid:Bool
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("Enter your verification code")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        .foregroundColor(.white)
                    
                    Text("This lets us confirm who you are")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                    
                    
                    TextField("Verification Code", text: $verificationCode, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.oneTimeCode)
                    //TODO: fix the keyboard
                        .keyboardType(.numberPad)
                        .onChange(of: self.verificationCode, perform: {value in
                            if value.count > 6 {
                                self.verificationCode = String(value.prefix(6))
                            }
                        })
                        .focused($focusedField, equals: .verificationCode)
                    
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
                .disabled(!isValid)
                .buttonStyle(BlueButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .keyboard){
                    Button("Done"){
                        focusedField = nil
                    }
                }
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct Screen5VerificationPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen5VerificationPure(didTapNextAction: {}, verificationCode: .constant("123"), isValid: true)
    }
}
