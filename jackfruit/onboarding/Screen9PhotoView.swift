//
//  Screen9PhotoView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-10.
//

import SwiftUI
import Combine
import os

final class Screen9PhotoVM: ObservableObject, Completeable {
    @Published var profilePhoto:UIImage?
    var phoneNumber = ""

    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Screen9PhotoVM.self)
    )
    
    let didComplete = PassthroughSubject<Screen9PhotoVM, Never>()
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    var isValid: Bool {
        profilePhoto != nil
    }
    
    
    func didTapNext(image: UIImage)  {
        self.profilePhoto = image
        //do some network calls etc
        didComplete.send(self)
    }
    
    
}


struct Screen9PhotoView: View {
    @StateObject var vm: Screen9PhotoVM
    @State var image: UIImage? = nil
    @State var progressValue: Float = 1.0
    @State private var editing = false
    @State var pickerSelected = false
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("Add profile photo?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .padding(.bottom, 20)
                    
                    Text("Share yourself with others!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .padding(.bottom, 40)
                    
                    
                    if let selectedImage = image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(20)
                    }
                    else {
                        Button(action: {
                            pickerSelected.toggle()
                        }, label: {
                            Text("Pick Images")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 35)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        })
                        //                        Button(action: {
                        //                            pickerSelected.toggle()
                        //                        }, label: { Text("Pick Image") })
                        //                        .padding(.vertical, 10)
                        //                        .padding(.horizontal, 35)
                        //                        .disabled(!vm.isValid)
                        //                        .buttonStyle(BlueButtonStyle())
                    }
                    
                    //                    TextField("Image", text: $vm.photoURL, onEditingChanged: { edit in
                    //                                    self.editing = edit
                    //                        }).padding(.bottom, 200)
                    //                        .textFieldStyle(MyTextFieldStyle(focused: $editing)).font(Font.custom("CircularStd-Book", size: 22))
                    //                        .textContentType(.addressCity)
                    //                        .textInputAutocapitalization(.words)
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
//                    self.vm.addToStorage(image: image!)
                    self.vm.didTapNext(image:image!)
                }, label: { Text(">") })
                
                
                .padding(.leading, 250)
                .padding(.bottom, 40)
                .disabled(image == nil)
                //                .disabled(!vm.isValid)
                .buttonStyle(BlueButtonStyle())
            }
        }
        .sheet(isPresented: $pickerSelected){
            ImagePicker(image: $image, showPicker: $pickerSelected)
        .ignoresSafeArea(.keyboard)

        }
    }
}

struct Screen9PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let testImage = UIImage(named: "Profilephoto.jpeg")
        Screen9PhotoView(vm: Screen9PhotoVM(phoneNumber: "5555555555"), image: testImage!)
    }
}
