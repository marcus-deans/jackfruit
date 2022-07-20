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
    
    var body: some View {
        Screen8ParametersPure(sportsToggledAction: vm.didToggleSports, hobbiesToggledAction: vm.didToggleHobbies, creativityToggledAction: vm.didToggleCreativity, travelingToggledAction: vm.didToggleTraveling, petsToggledAction: vm.didTogglePets, didTapNextAction: vm.didTapNext)
    }
}

struct Screen8ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        Screen8ParametersView(vm: Screen8ParametersVM(parameters: ["traveling", "pets"]))
    }
}
