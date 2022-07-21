//
//  Screen8ParametersPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI
import WrappingHStack

struct Screen8ParametersPure: View {
    //    @StateObject var vm: Screen8ParametersVM
    
    let sportsToggledAction: () -> Void
    let hobbiesToggledAction: () -> Void
    let creativityToggledAction: () -> Void
    let travelingToggledAction: () -> Void
    let petsToggledAction: () -> Void
    let didTapNextAction: () -> Void
    
    @State var sportsIsSelected : Bool = false
    @State var creativityIsSelected : Bool = false
    @State var travelingIsSelected : Bool = false
    @State var hobbiesIsSelected : Bool = false
    @State var petsIsSelected : Bool = false
    
    @State var progressValue: Float = 1.0
    @State private var editing = false
    
    @State var sportsActivities: [String] = activitiesSports
    @State var selectedActivities: [String] = []
    let elements = ["Cat 🐱", "Dog 🐶", "Sun 🌞", "Moon 🌕", "Tree 🌳"]
    
    var body: some View {
        
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            VStack {
                
                GeometryReader { _ in
                    VStack(alignment: .leading) {
                        
                        ProgressBar(value: $progressValue).frame(height: 10)
                        
                        Text("What are some things that describe who you are?")
                            .font(Font.custom("CircularStd-Black", size: 40))
                            .padding(.bottom, 20)
                        
                        Text("When you share your contact this information will be shared too!")
                            .font(Font.custom("CircularStd-Book", size: 20))
                        
                    }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.init(UIColor.transitionPage))
                }
            
                ScrollView{
                //MARK: the HStack WE are using is https://github.com/dkk/WrappingHStack
                WrappingHStack(sportsActivities, id: \.self){ activity in
                    ActivityButton(title: activity, isSelected: self.selectedActivities.contains(activity)){
                        if self.selectedActivities.contains(activity){
                            self.selectedActivities.removeAll(where: {$0 == activity})
                        } else {
                            self.selectedActivities.append(activity)
                        }
                    }
                }
//                .padding(.horizontal, 30)

                
                WrappingHStack {
                    Button(action: {sportsToggledAction()
                        self.sportsIsSelected.toggle()
                    }, label: {Text("Sports")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.sportsIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.sportsIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 17).padding(.horizontal, 4)
                    
                    Button(action: {creativityToggledAction()
                        self.creativityIsSelected.toggle()
                    }, label: {Text("Creativity")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.creativityIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.creativityIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 17).padding(.horizontal, 4)
                    
                    
                    Button(action: {travelingToggledAction()
                        self.travelingIsSelected.toggle()
                    }, label: {Text("Traveling")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.travelingIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.travelingIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
                    
                    
                    
                    Button(action: {hobbiesToggledAction()
                        self.hobbiesIsSelected.toggle()
                    }, label: {Text("Hobbies")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.hobbiesIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.hobbiesIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
                    
                    
                    Button(action: {petsToggledAction()
                        self.petsIsSelected.toggle()
                    }, label: {Text("Pets")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.petsIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.petsIsSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
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
        .frame(height: 40, alignment: .center)
        .padding(.horizontal, 15)
        .background(isSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white))
        .cornerRadius(20)
        .foregroundColor(.black)
        .font(Font.custom("PTSans-Bold", size: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
        )
        .padding(.bottom, 10)
        .padding(.horizontal, 4)
//        .padding(.bottom, 100).padding(.horizontal, 4)
    }
}

struct Screen8ParametersPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen8ParametersPure(sportsToggledAction: {}, hobbiesToggledAction: {}, creativityToggledAction: {}, travelingToggledAction: {}, petsToggledAction: {}, didTapNextAction: {})
    }
}
