//
//  ContactsAddView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-18.
//

import SwiftUI

struct ContactsAddView: View {
    let addWorkContactAction: (String) -> Void
    let addGroupContactAction: (String) -> Void
    let addFriendContactAction: (String) -> Void
    
    enum relationTypes {
        case friend
        case work
        case group
    }
    var selectedRelation: relationTypes = .work
    
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
                    AddRelationButtonView(isChecked: $addSelected, trimVal: $trimVal, width: $width, removeText:$removeText )
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
                            case .friend:
                                addFriendContactAction(value)
                            case .work:
                                addWorkContactAction(value)
                            case .group:
                                addGroupContactAction(value)
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
}

struct AddRelationButtonView: View {
    @Binding var isChecked : Bool
    @Binding var trimVal : CGFloat
    @Binding var width : CGFloat
    @Binding var removeText : Bool
    var t1 = "Add Number"
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
            if !removeText {
                Text(""+t1)
                    .foregroundColor(Color.init(UIColor.white)).font(Font.custom("CircularStd-Black", size: 18))
                    .foregroundColor(Color.init(UIColor.white))
            }
        }
    }
}

struct ContactsAddView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsAddView(
            addWorkContactAction: { value in
                print(value)
            },
            addGroupContactAction: { value in
                print(value)
            },
            addFriendContactAction: { value in
                print(value)
            }
        )
    }
}
