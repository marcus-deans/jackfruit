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
    
    var body: some View{
        Screen4NumberPure(didTapNextAction: vm.didTapNext, phoneNumber: $vm.phoneNumber)
    }
}
