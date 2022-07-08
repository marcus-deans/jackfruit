//
//  FlowView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI

struct FlowView: View {
    
    @StateObject var vm: FlowVM
//    @EnvironmentObject var appState: AppState
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    // Note the generation of view models here is only done once
    // as long as the view models are referenced as @StateObject and not @ObservedObject
     
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    var body: some View {
        NavigationView {
            VStack() {
                Flow(next: $vm.navigateTo1){
                    Screen1LandingView(vm: vm.makeScreen1LandingView())
                    .transition(transition)
                    Flow(next: $vm.navigateTo2) {
                        Screen2FirstNameView(vm: vm.makeScreen2StandardView())
                            .transition(transition)
                        Flow(next: $vm.navigateTo3) {
                            Screen3LastNameView(vm: vm.makeScreen3DetailsView())
                                .transition(transition)
                            Flow(next: $vm.navigateTo4) {
                                Screen4NumberView(vm: vm.makeScreen4NumberView())
                                    .transition(transition)
                                Flow(next: $vm.navigateTo5) {
                                    Screen5VerificationView(vm: vm.makeScreen5VerificationView())
                                        .transition(transition)
                                    Flow(next: $vm.navigateTo6) {
                                        Screen6EmailView(vm: vm.makeScreen6EmailView())
                                            .transition(transition)
                                        Flow(next: $vm.navigateTo7) {
                                            Screen7LocationView(vm: vm.makeScreen7LocationView())
                                                .transition(transition)
                                            Flow(next: $vm.navigateTo8) {
                                                Screen8ParametersView(vm: vm.makeScreen8ParametersView())
                                                    .transition(transition)
                                                Flow(next: $vm.navigateTo9){
                                                    Screen9CompletionView(vm: vm.makeScreen9CompletionView())
                                                        .transition(transition)
                                                    Flow(next: $vm.navigateToHome){
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .navigationViewStyle(.stack)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
