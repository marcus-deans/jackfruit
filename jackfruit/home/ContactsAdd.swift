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
                .foregroundColor(self.checked1 ? Color.green : Color.gray)
                .overlay(
                    Capsule()
                        .fill(self.checked1 ? Color.green : Color.init(UIColor.activitiesLeft).opacity(0.5))
                        .opacity(self.checked1 ? 0 : 1)
                        .frame(width: 200, height: 55)
                        .foregroundColor(Color.white)
                )
            if checked1 {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white).opacity(Double(trimVal))
            }
            if !removeText {
                Text(""+t1)
                    .foregroundColor(.white).font(Font.custom("PTSans-Bold", size: 18))
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct ContactsAdd: View {
    var relation = ["Personal ❤️", "Professional 💼", "Group 🏘"]
    @State private var selectedRelation = "Professional 💼"
    @State var value = "0"
    @ObservedObject var viewModel = ContactsAddVM()
    @AppStorage("user_id") var userId: String = ""
    @State var isSelected : Bool = false
    @State var isSelected1 : Bool = false
    @State var isSelected2 : Bool = false
    
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
            //Color.init(UIColor.transitionPage).ignoresSafeArea()
            RadialGradient(gradient: Gradient(colors: [.init(UIColor.transitionPage), .orange]), center: .center, startRadius: 2, endRadius: 650).ignoresSafeArea()
            VStack {
                VStack(alignment: .center, spacing: -1, content: {
                    HStack{
                        Text(value)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(Font.custom("CircularStd-Black", size: 50))
                            .padding()
                            .foregroundColor(.white)
                    }
                    .padding()
//                    Picker("Choose a relationship", selection: $selectedRelation) {
//                        ForEach(relation, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .frame(height: 110)
                    
                    
                    HStack {
                        Button(action: {
                            self.isSelected.toggle()
                        }, label: {Text("Friend")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected ? Color.init(UIColor.green).opacity(0.5) : Color.init(UIColor.activitiesLeft).opacity(0.5)).cornerRadius(20).foregroundColor(.white).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(self.isSelected ? Color.init(UIColor.green) : Color.init(UIColor.activitiesLeft))
                        ).padding(.bottom, 17).padding(.horizontal, 4)
                        
                        Button(action: {
                            self.isSelected1.toggle()
                        }, label: {Text("Work")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected1 ? Color.init(UIColor.green).opacity(0.5) : Color.init(UIColor.activitiesLeft).opacity(0.5)).cornerRadius(20).foregroundColor(.white).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(self.isSelected1 ? Color.init(UIColor.green) : Color.init(UIColor.activitiesLeft))
                        ).padding(.bottom, 17).padding(.horizontal, 4)
                        
                        Button(action: {
                            self.isSelected2.toggle()
                        }, label: {Text("Group")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected2 ? Color.init(UIColor.green).opacity(0.5) : Color.init(UIColor.activitiesLeft).opacity(0.5)).cornerRadius(20).foregroundColor(.white).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(self.isSelected2 ? Color.init(UIColor.green) : Color.init(UIColor.activitiesLeft))
                        ).padding(.bottom, 17).padding(.horizontal, 4)
                        
                        
                        
                    }
                    
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
                                    .font(Font.custom("CircularStd-Black", size: 35))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(Color.clear)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                            })
                        }
                    }
                }
                Spacer()
                    .frame(height: 20)
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
