//
//  Screen4NumberView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import Combine
import iPhoneNumberField

final class Screen4NumberVM: ObservableObject, Completeable {
    @Published var phoneNumber = ""
    
    let didComplete = PassthroughSubject<Screen4NumberVM, Never>()
    let skipRequested = PassthroughSubject<Screen4NumberVM, Never>()
    
    //TODO: implement more robust field validation using Combine
    var isValid: Bool {
        !phoneNumber.isEmpty
    }
    
    init(phoneNumber: String?) {
        self.phoneNumber = phoneNumber ?? ""
    }
    
    
    func didTapNext() {
        //do some network calls etc
        guard isValid else {
            return
        }
        print(phoneNumber)
        //do some network calls etc
        didComplete.send(self)
    }
    
    fileprivate func didTapSkip() {
        skipRequested.send(self)
    }
    
    func removePhoneFormat(phone: String) -> String{
        let digits = CharacterSet.decimalDigits
        var text = ""
        for ch in phone.unicodeScalars{
            if digits.contains(ch){
                text.append(ch.description)
            }
        }
        return text
    }
    
    func phoneFormat(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            }
            else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = phoneFormat(with: "(XXX) XXX_XXXX", phone: newString)
        return string == " "
    }
}

struct Screen4NumberView: View {
    @StateObject var vm: Screen4NumberVM
    @State private var editing = false
    @State var progressValue: Float = 0.48
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("user_id") var userId: String = ""
    @FocusState private var focusedField: Field?
    
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
                    
                    Text("We'll use this to link to your contacts")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                    
                    
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
                    
                    TextField("Phone Number", text: $vm.phoneNumber, onEditingChanged: {edit in self.editing=edit})
                        .onChange(of: self.vm.phoneNumber, perform: {value in
                            if value.count > digitLimit {
                                self.vm.phoneNumber = String(value.prefix(digitLimit))
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
                    userId = vm.phoneNumber
                    self.vm.didTapNext()
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .disabled(!vm.isValid)
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

struct Screen4NumberView_Previews : PreviewProvider {
    static var previews: some View {
        Screen4NumberView(vm: Screen4NumberVM(phoneNumber: "9196414032"))
    }
}
