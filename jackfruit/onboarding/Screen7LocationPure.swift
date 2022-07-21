//
//  Screen7LocationPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen7LocationPure: View {
    let didTapNextAction: () -> Void
    
    @State private var editing = false
    @State var progressValue: Float = 0.75
    @State private var keyboardHeight: CGFloat = 0
    @Binding var location:String
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("Where do you live?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        .foregroundColor(.white)
                    
                    Text("This information can be used by your contacts if they ever come to your city!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                    
                    
                    TextField("Location", text: $location, onEditingChanged: { edit in
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
                    didTapNextAction()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .buttonStyle(BlueButtonStyle())
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct Screen7LocationPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen7LocationPure(didTapNextAction: {}, location: .constant("Windsor"))
    }
}
