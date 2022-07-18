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
    case clear = "⌫"
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

struct ContactsAdd: View {
    @ObservedObject var viewModel = ContactsAddVM()

    var relation = ["Personal ❤️", "Professional 💼", "Group 🏘"]
    @State private var selectedRelation = "Professional 💼"
    @State var value = "0"
    @AppStorage("user_id") var userId: String = ""
    @State var friendSelected : Bool = false
    @State var workSelected : Bool = false
    @State var groupSelected : Bool = false
    @State var addSelected = false

    let buttons: [[CalcButton]] = [
        [.one, .two, .three],
        [.four, .five, .six],
        [.seven, .eight, .nine],
        [.hash, .zero, .clear],
    ]
    @State var trimVal : CGFloat = 0
    @State var width : CGFloat = 70
    @State var removeText = false
    var body: some View {
        ZStack{
            Color.init(UIColor.middleColor)
            
            VStack {
                VStack(alignment: .center, spacing: -1, content: {
                    HStack{
                        Text(value)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(Font.custom("CircularStd-Black", size: 50))
                            .padding()
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            self.friendSelected.toggle()
                        }, label: {Text("Friend")})
                        .frame(height: 40, alignment: .center)
                        .padding(.horizontal, 15)
                        .background(self.friendSelected ? Color.init(UIColor.green) : Color.init(UIColor.transitionPage)).cornerRadius(12)
                            .foregroundColor(Color.init(UIColor.white)).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(self.friendSelected ? Color.init(UIColor.clear) : Color.init(UIColor.clear))
                            )
                            .padding(.bottom, 17).padding(.horizontal, 4)
                        
                        Button(action: {
                            self.workSelected.toggle()
                        }, label: {Text("Work")})
                        .frame(height: 40, alignment: .center)
                        .padding(.horizontal, 15)
                        .background(self.workSelected ? Color.init(UIColor.green) : Color.init(UIColor.transitionPage)).cornerRadius(12)
                            .foregroundColor(Color.init(UIColor.white)).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(self.friendSelected ? Color.init(UIColor.clear) : Color.init(UIColor.clear))
                            )
                            .padding(.bottom, 17).padding(.horizontal, 4)
                        
                        Button(action: {
                            self.groupSelected.toggle()
                        }, label: {Text("Group")})
                        .frame(height: 40, alignment: .center)
                        .padding(.horizontal, 15)
                        .background(self.groupSelected ? Color.init(UIColor.green) : Color.init(UIColor.transitionPage)).cornerRadius(12)
                            .foregroundColor(Color.init(UIColor.white)).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(self.friendSelected ? Color.init(UIColor.clear) : Color.init(UIColor.clear))
                            )
                            .padding(.bottom, 17).padding(.horizontal, 4)
                        
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
                                    .font(Font.custom("CircularStd-Black", size: 50))
                                    .frame(
                                        width: 100,
                                        height: 80
                                    ).background(
                                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                                            .foregroundColor(.init(UIColor.clear ))
                                            .shadow(radius: 1)
                                    )
                                    .foregroundColor(Color.init(UIColor.black))
                                    .padding(.horizontal, 1)
                            })
                        }
                    }
                }
                Spacer()
                    .frame(height: 20)
                Button(action: {
                    if !self.addSelected{
                        withAnimation(Animation.easeIn(duration: 0.8)) {
                            self.trimVal = 1
                            self.addSelected.toggle()
                        }
                    }
                })
                {
                    AddRelationButtonView(isChecked: $addSelected, trimVal: $trimVal, width: $width, hideTextLabel:$removeText )
                        .onTapGesture {
                            if !self.addSelected {
                                self.removeText.toggle()
                                withAnimation{
                                    self.width = 70
                                }
                                withAnimation(Animation.easeIn(duration: 0.7)) {
                                    self.trimVal = 1
                                    self.addSelected.toggle()
                                }
                            } else {
                                withAnimation{
                                    self.trimVal = 0
                                    self.width = 200
                                    self.addSelected.toggle()
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
        case .clear: // clear funciton
            value = "0"
            break
        default:
            let number = button.rawValue
            if value == "0" {
                value = number
            } else {
                value = "\(value)\(number)"
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
