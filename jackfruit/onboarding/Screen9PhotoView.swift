//
//  Screen9PhotoView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-10.
//

import SwiftUI
import Combine

final class Screen9PhotoVM: ObservableObject, Completeable {
    @Published var photoURL: String?
    
    let didComplete = PassthroughSubject<Screen9PhotoVM, Never>()
    
    init(photoURL: String?) {
        self.photoURL = photoURL ?? ""
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}


struct Screen9PhotoView: View {
    @StateObject var vm: Screen9PhotoVM
    @AppStorage("is_onboarded") var isOnboarded: Bool = false
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage).ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Welcome to the app")  .font(Font.custom("PTSans-Bold", size: 34))
                    .fontWeight(.black).bold()
        
                Button(action: {
                    withAnimation(.spring()){
                        self.vm.didTapNext()
//                        isOnboarded=true
                    }
                }, label: { Text("Next") }).buttonStyle(RoundedRectangleButtonStyle())
            }.padding()
        }
    }
}

struct Screen9PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        Screen9PhotoView(vm: Screen9PhotoVM(photoURL: ""))
    }
}
