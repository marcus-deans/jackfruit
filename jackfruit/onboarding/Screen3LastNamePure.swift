//
//  Screen3LastNamePure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen3LastNamePure: View {
    let didTapNextAction: () -> Void
    
    @State private var editing = false
    @State var progressValue: Float = 0.3
    @State private var keyboardHeight: CGFloat = 0
    
    @Binding var lastName:String
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("What's your last name?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        .foregroundColor(.white)
                    
                    Text("You won't be able to change this later!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                    
                    
                    TextField("Last Name", text: $lastName, onEditingChanged: { edit in
                        self.editing = edit
                    }).padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.familyName)
                        .textInputAutocapitalization(.words)
                    
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

struct Screen3LastNamePure_Previews: PreviewProvider {
    static var previews: some View {
        Screen3LastNamePure(didTapNextAction: {}, lastName: .constant("Deans"))
    }
}
