//
//  Screen8ParametersView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//


import WrappingHStack
import SwiftUI
import Combine

final class Screen8ParametersVM: ObservableObject, Completeable {
    @Published var parameters: [String]?
    
    let didComplete = PassthroughSubject<Screen8ParametersVM, Never>()
    let goToRootRequested = PassthroughSubject<Screen8ParametersVM, Never>()
    
    
    init(parameters: [String]?) {
        self.parameters = []
    }
    
    func didToggleSports(){
        self.parameters!.append("sports")
    }
    
    func didToggleCreativity(){
        self.parameters!.append("creativity")
    }
    
    func didToggleTraveling(){
        self.parameters!.append("traveling")
    }
    
    func didToggleHobbies(){
        self.parameters!.append("hobbies")
    }
    
    func didTogglePets(){
        self.parameters!.append("pets")
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}

struct Screen8ParametersView: View {
    @StateObject var vm: Screen8ParametersVM
    
    @State var isSelected : Bool = false
    @State var isSelected1 : Bool = false
    @State var isSelected2 : Bool = false
    @State var isSelected3 : Bool = false
    @State var isSelected4 : Bool = false
    @State var isSelected5 : Bool = false
    @State var progressValue: Float = 1.0
    @State private var editing = false
    
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
                
                WrappingHStack {
                    Button(action: {self.vm.didToggleSports()
                        self.isSelected.toggle()
                    }, label: {Text("Sports")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.isSelected ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 17).padding(.horizontal, 4)
                    
                    Button(action: {self.vm.didToggleCreativity()
                        self.isSelected1.toggle()
                    }, label: {Text("Creativity")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected1 ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.isSelected1 ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 17).padding(.horizontal, 4)
                    
                    
                    Button(action: {self.vm.didToggleTraveling()
                        self.isSelected2.toggle()
                    }, label: {Text("Traveling")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected2 ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.isSelected2 ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
                    
                    
                    
                    Button(action: {self.vm.didToggleHobbies()
                        self.isSelected4.toggle()
                    }, label: {Text("Hobbies")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected4 ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.isSelected4 ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
                    
                    
                    Button(action: {self.vm.didTogglePets()
                        self.isSelected5.toggle()
                    }, label: {Text("Pets")}).frame(height: 40, alignment: .center).padding(.horizontal, 15).background(self.isSelected5 ? Color.init(UIColor.afterStartPageTransition) : Color.init(UIColor.white)).cornerRadius(20).foregroundColor(.black).font(Font.custom("PTSans-Bold", size: 18)).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(self.isSelected5 ? Color.init(UIColor.afterStartPageTransition) : Color.white)
                    ).padding(.bottom, 100).padding(.horizontal, 4)
                    
                }.padding(.horizontal, 40)
                
                VStack (alignment: .trailing) {
                    
                    Button(action: {
                        self.vm.didTapNext()
                    }, label: { Text(">") })
                    
                    
                    .padding(.leading, 250)
                    .padding(.bottom, 40)
                    .buttonStyle(BlueButtonStyle())
                }
            }
        }
    }
}

struct Screen8ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        Screen8ParametersView(vm: Screen8ParametersVM(parameters: ["traveling", "pets"]))
    }
}
