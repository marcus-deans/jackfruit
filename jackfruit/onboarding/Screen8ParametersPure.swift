//
//  Screen8ParametersPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI
import WrappingHStack

struct Screen8ParametersPure: View {
    let didTapNextAction: () -> Void

    
    @State var progressValue: Float = 0.875
    @State private var editing = false
    
    @State var sportsActivities: [String] = Sports
    @State var artsActivities: [String] = Art
    @State var outdoorActivities: [String] = Outdoors
    @State var entertainmentActivities: [String] = Entertainment
    @State var musicActivities: [String] = Music
    @State var foodActivities: [String] = Food
    @State var funActivities: [String] = Fun
    @State var profInterests: [String] = ProfessionalInterests
    @State var miscInterests: [String] = Misc
    @State var learningActivities: [String] = Learning
    
    @Binding var selectedActivities: [String]
    
    let activityLimit = 8
    
    let elements = ["Cat 🐱", "Dog 🐶", "Sun 🌞", "Moon 🌕", "Tree 🌳"]
    
    var body: some View {
        
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            ScrollView {
                
                    VStack(alignment: .leading) {
                        
                        ProgressBar(value: $progressValue).frame(height: 10)
                        
                        Text("What 8 things best define you?")
                            .font(Font.custom("CircularStd-Black", size: 40))
                            .padding(.bottom, 20)
                            .foregroundColor(.white)
                        
                        Text("When you share your contact this information will be shared too!")
                            .font(Font.custom("CircularStd-Book", size: 20))
                            .foregroundColor(.white)
                        
                    }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.init(UIColor.transitionPage))
            
                VStack {
                    
                    Text("Entertainment").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(entertainmentActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                        
                    Text("Outdoors").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(outdoorActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                        
                    Text("Sports").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(sportsActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                
                    Text("Music").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(musicActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                                            
                    Text("Food").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(foodActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    
                }.padding(.horizontal, 40)
                    .padding(.vertical, 20)
                
                VStack() {
                    Text("Arts").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(artsActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    
                    Text("Fun").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(funActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    
                    Text("Professional Interests").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(profInterests, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    
                    Text("Miscellaneous").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(miscInterests, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit) {
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    Text("Learning").font(Font.custom("CircularStd-Black", size: 30)).underline(true, color: Color.init(UIColor.yellow)).foregroundColor(.white)
                    WrappingHStack(learningActivities, id: \.self){ activity in
                        ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                            if self.selectedActivities.contains(activity){
                                self.selectedActivities.removeAll(where: {$0 == activity})
                            } else if (self.selectedActivities.count < activityLimit){
                                self.selectedActivities.append(activity)
                            }
                        }
                    }
                    
                    
                }.padding(.horizontal, 40)
                
                VStack (alignment: .trailing) {
                    
                    Button(action: {
                        didTapNextAction()
                    }, label: { Text(">") })
                    
                    
                    .padding(.leading, 250)
                    .padding(.bottom, 40)
                    .buttonStyle(BlueButtonStyle())
                }
            }
        }
    }
}

struct ActivityButton: View{
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {action()
        }, label: {Text(title)})
//        .frame(width: 50, height: 40)
//        .padding(.horizontal, 15)
        .frame(height: 35, alignment: .center)
        .padding(.horizontal, 15)
        .background(isSelected ? Color.init(UIColor.yellow) : Color.init(UIColor.white))
        .cornerRadius(20)
        .foregroundColor(.black)
        .font(Font.custom("CircularStd-Black", size: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.init(UIColor.yellow) : Color.white)
        )
        .padding(.bottom, 10)
        .padding(.horizontal, 4)
    }
}

struct Screen8ParametersPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen8ParametersPure(didTapNextAction: {}, selectedActivities: .constant([]))
    }
}
