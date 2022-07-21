//
//  Screen4NumberPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen4NumberPure: View {
    let didTapNextAction: () -> Void
    
    @State private var editing = false
    @State var progressValue: Float = 0.375
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("user_id") var userId: String = ""
    @FocusState private var focusedField: Field?
    
    @Binding var phoneNumber:String
    
    let digitLimit: Int = 10
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("What's your phone number?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                        .foregroundColor(.white)
                    
                    Text("We'll use this to link to your contacts")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                    
                    
                    //                    iPhoneNumberField("(000) 000-0000", text: $vm.phoneNumber, isEditing: $editing)
                    //                        .clearsOnEditingBegan(true)
                    //                        .clearButtonMode(.whileEditing)
                    //                        .maximumDigits(10)
                    //                        .foregroundColor(Color.black)
                    //                        .onClear{_ in editing.toggle()}
                    //                        .font(UIFont(size: 22, design: .monospaced))
                    //                        .prefixHidden(true)
                    //                        .flagHidden(false)
                    //                        .accentColor(Color.white)
                    ////                        .padding()
                    //                        .cornerRadius(20)
                    //                        .shadow(color: editing ? Color(UIColor.greenShaddow) : Color(UIColor.greenBackground), radius: 4)
                    //                        .background(Color.white)
                    //                        .padding()
                    //                        .padding(.bottom, 200)
                    //                        .background(RoundedRectangle(cornerRadius: 9, style: .continuous)
                    //                            .foregroundColor(.white)
                    //                            .shadow(color: editing ? Color(UIColor.greenShaddow) : Color(UIColor.greenBackground), radius: 4, x: 0, y:5)
                    //                        )
                    //                        .border(Color.white)
                    
                    TextField("Phone Number", text: $phoneNumber, onEditingChanged: {edit in self.editing=edit})
                        .onChange(of: self.phoneNumber, perform: {value in
                            if value.count > digitLimit {
                                self.phoneNumber = String(value.prefix(digitLimit))
                            }
                        })
                        .padding(.bottom, 200)
                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .phoneNumber)
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
                    userId = phoneNumber
                    didTapNextAction()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
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

struct Screen4NumberPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen4NumberPure(didTapNextAction: {}, phoneNumber: .constant("9196414032"))
    }
}
