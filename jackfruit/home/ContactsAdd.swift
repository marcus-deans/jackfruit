//
//  ContactsAdd.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI
import FirebaseFirestore

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "X"
    case equal = "="
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    case star = "⌫"
    case hash = "#"
}

class ContactsAddVM: ObservableObject {
    let db = Firestore.firestore()
    
    func addPersonalRelationship(userId: String, personalContact: String){
        let currentUserRef = db.collection("users").document(userId)
        currentUserRef.updateData([
            "personal_contacts": FieldValue.arrayUnion([personalContact])
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func addProfessionalRelationship(userId: String, professionalContact: String){
        let currentUserRef = db.collection("users").document(userId)
        currentUserRef.updateData([
            "professional_contacts": FieldValue.arrayUnion([professionalContact])
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func addGroup(userId: String, groupId: String){
        // Update one field, creating the document if it does not exist.
        db.collection("groups").document(groupId).setData([ "members": FieldValue.arrayUnion([userId]) ], merge: true)
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct CheckBoxView1: View {
    @Binding var checked1 : Bool
    @Binding var trimVal : CGFloat
    @Binding var width : CGFloat
    @Binding var removeText : Bool
    var t1 = "Add User"
    var animatableData: CGFloat {
        get{trimVal}
        set{trimVal = newValue }
    }
    var body: some View {
        ZStack{
            Capsule()
                .trim(from: 0, to: trimVal)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .frame(width: 40, height: 55)
                .foregroundColor(self.checked1 ? Color.blue : Color.gray)
                .overlay(
                    Capsule()
                        .fill(self.checked1 ? Color.blue : Color.gray.opacity(0.2))
                        .opacity(self.checked1 ? 0 : 1)
                        .frame(width: 200, height: 55)
                    //   .foregroundColor(self.checked3 ? Color.gray : Color.white)
                )
            if checked1 {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.black).opacity(Double(trimVal))
            }
            if !removeText {
                Text(""+t1)
                    .bold()
            }
        }
    }
}



struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.red
            }
        }
    }
}
struct ContactsAdd: View {
    var relation = ["Personal ❤️", "Professional 💼", "Group 🏘"]
    @State private var selectedRelation = "Professional 💼"
    @State var value = ""
    @ObservedObject var viewModel = ContactsAddVM()
    @AppStorage("user_id") var userId: String = ""
    
    let buttons: [[CalcButton]] = [
        [.one, .two, .three],
        [.four, .five, .six],
        [.seven, .eight, .nine],
        [.star, .zero, .hash],
    ]
    @State var trimVal : CGFloat = 0
    @State var checked1 = false
    @State var checked2 = false
    @State var checked3 = false
    @State var width : CGFloat = 70
    @State var removeText = false
    @State var checked = false
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Add A Contact")
                    .bold()
                    .font(.system(size:42))
                    .foregroundColor(.black)
                VStack(alignment: .center, spacing: -1, content: {
                    HStack{
                        Text(value)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(.system(size: 32))
                            .padding()
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .padding()
                    Picker("Choose a relationship", selection: $selectedRelation) {
                        ForEach(relation, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 110)
                    Spacer()
                        .frame(height: 20)
                })
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 30))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                }
                Spacer()
                    .frame(height: 15)
                Button(action: {
                    if !self.checked1{
                        withAnimation(Animation.easeIn(duration: 0.8)) {
                            self.trimVal = 1
                            self.checked1.toggle()
                        }
                    }
                })
                {
                    CheckBoxView1(checked1: $checked1, trimVal: $trimVal, width: $width, removeText:$removeText )
                        .onTapGesture {
                            if !self.checked1 {
                                self.removeText.toggle()
                                withAnimation{
                                    self.width = 70
                                }
                                withAnimation(Animation.easeIn(duration: 0.7)) {
                                    self.trimVal = 1
                                    self.checked1.toggle()
                                }
                            } else {
                                withAnimation{
                                    self.trimVal = 0
                                    self.width = 200
                                    self.checked1.toggle()
                                    self.removeText.toggle()
                                }
                            }
                            switch selectedRelation{
                            case relation[0]:
                                viewModel.addPersonalRelationship(userId: userId, personalContact: value)
                            case relation[1]:
                                viewModel.addProfessionalRelationship(userId: userId, professionalContact: value)
                            case relation[2]:
                                viewModel.addGroup(userId: userId, groupId: value)
                            default: break
                            }
                        }
                }
            }
        }
    }
    func didTap(button: CalcButton) {
        switch button {
        case .star: // clear funciton
            self.value = "0"
            break
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            } else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (7*20)) / 4)
        }
        return (UIScreen.main.bounds.width - (7*20)) / 4
    }
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (7*20)) / 4
    }
    
    
    
    struct ContactsAdd_Previews: PreviewProvider {
        static var previews: some View {
            ContactsAdd()
        }
    }
}
