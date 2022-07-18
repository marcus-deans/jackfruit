//
//  ContactsAddView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-18.
//

import SwiftUI

enum NumberButton: String {
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
    case delete = "⌫"
    case clear = "C"
}

struct ContactsAddView: View {
    let addWorkContactAction: (String) -> Void
    let addGroupContactAction: (String) -> Void
    let addFriendContactAction: (String) -> Void
    
    
    @State var enteredNumber = ""
    @AppStorage("user_id") var userId: String = ""
    @State var friendSelected : Bool = false
    @State var workSelected : Bool = false
    @State var groupSelected : Bool = false
    @State var addSelected = false
    
    enum relationType {
        case friend
        case work
        case group
        case none
    }
    @State var selectedRelation: relationType = .none
    
    let buttons: [[NumberButton]] = [
        [.one, .two, .three],
        [.four, .five, .six],
        [.seven, .eight, .nine],
        [.clear, .zero, .delete],
    ]
    @State var trimVal : CGFloat = 0
    @State var width : CGFloat = 70
    @State var hideTextLabel = false
    var body: some View {
        ZStack{
            Color.init(UIColor.middleColor)
            
            VStack {
                VStack(alignment: .center, spacing: -1, content: {
                    HStack{
                        Text(enteredNumber)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(Font.custom("CircularStd-Black", size: 50))
                            .padding()
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            self.friendSelected.toggle()
                            self.selectedRelation = .friend
                            self.workSelected = false
                            self.groupSelected = false
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
                            self.selectedRelation = .work
                            self.friendSelected = false
                            self.groupSelected = false
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
                            self.selectedRelation = .group
                            self.friendSelected = false
                            self.workSelected = false
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
//                    if !self.addSelected{
//                        withAnimation(Animation.easeIn(duration: 0.8)) {
//                            self.trimVal = 1
//                            self.addSelected.toggle()
//                        }
//                    }
                })
                {
                    AddRelationButtonView(isChecked: $addSelected, trimVal: $trimVal, width: $width, hideTextLabel: $hideTextLabel )
                        .onTapGesture {
                            guard selectedRelation != .none else {
//                                self.addSelected.toggle()
                                print("No relation selected")
                                return
                            }
                            guard enteredNumber.count == 10 else {
//                                self.addSelected.toggle()
                                print("Entered number is invalid")
                                return
                            }
                            self.hideTextLabel.toggle()
                            withAnimation(Animation.easeIn(duration: 0.5)){
                                self.width = 70
                                self.trimVal = 1
                                self.addSelected.toggle()
                                self.hideTextLabel.toggle()
                                print("Trimmed button")
                            }
                            withAnimation(Animation.spring().delay(4)) {
                                self.trimVal = 0
                                self.width = 200
                                self.addSelected.toggle()
                                self.hideTextLabel.toggle()
                                self.enteredNumber = ""
                                print("Reset button")
                            }
                            
                            switch selectedRelation{
                            case .friend:
                                addFriendContactAction(enteredNumber)
                            case .work:
                                addWorkContactAction(enteredNumber)
                            case .group:
                                addGroupContactAction(enteredNumber)
                            case .none:
                                print("Error")
                            }
                        }
                }
            }
        }
    }
    func didTap(button: NumberButton) {
        switch button {
        case .delete:
            enteredNumber.removeLast()
            break
        case .clear: // clear funciton
            enteredNumber = ""
            break
        default:
            let number = button.rawValue
            if enteredNumber == "" {
                enteredNumber = number
            } else {
                enteredNumber = "\(enteredNumber)\(number)"
            }
        }
    }
    func buttonWidth(item: NumberButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (7*20)) / 4)
        }
        return (UIScreen.main.bounds.width - (7*20)) / 4
    }
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (7*20)) / 4
    }
}

struct AddRelationButtonView: View {
    @Binding var isChecked : Bool
    @Binding var trimVal : CGFloat
    @Binding var width : CGFloat
    @Binding var hideTextLabel : Bool
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
                .foregroundColor(self.isChecked ? Color.green : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(self.isChecked ? Color.green : Color.init(UIColor.transitionPage))
                        .opacity(self.isChecked ? 0 : 1)
                        .frame(width: 200, height: 55)
                        .foregroundColor(Color.init(UIColor.white))
                )
            if isChecked {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.black).opacity(Double(trimVal))
            }
            if !hideTextLabel {
                Text("Add Number")
                    .foregroundColor(Color.init(UIColor.white))
                    .font(Font.custom("CircularStd-Black", size: 18))
            }
        }
    }
}

struct ContactsAddView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsAddView(
            addWorkContactAction: { enteredNumber in
                print(enteredNumber)
            },
            addGroupContactAction: { enteredNumber in
                print(enteredNumber)
            },
            addFriendContactAction: { enteredNumber in
                print(enteredNumber)
            }
        )
    }
}
