//
//  Screen9PhotoPure.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-20.
//

import SwiftUI

struct Screen9PhotoPure: View {
    @State var image: UIImage? = nil
    @State var progressValue: Float = 0.75
    @State private var editing = false
    @State var pickerSelected = false
    
    let didTapNextAction: (UIImage) -> Void
    
    var body: some View {
        ZStack {
            Color.init(UIColor.transitionPage)
                .ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    
                    ProgressBar(value: $progressValue).frame(height: 10)
                    
                    Text("Add profile photo?")
                        .font(Font.custom("CircularStd-Black", size: 40))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Text("Photos help your contacts remeber you!")
                        .font(Font.custom("CircularStd-Book", size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                    
                    
                    if let selectedImage = image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 220, height: 220, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.init(UIColor.yellow), lineWidth: 10))
                    }
                    else {
                        Button(action: {
                            pickerSelected.toggle()
                        }, label: {
                            Text("Pick Image")
                        })
                        .buttonStyle(RoundedRectangleButtonStyle())
                        .padding()
                    }
                    
                }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.init(UIColor.transitionPage))
            }
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(minHeight: 15, idealHeight: 52, maxHeight: .infinity)
                Button(action: {
                    //                    self.vm.addToStorage(image: image!)
                    didTapNextAction(image!)
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

struct Screen9PhotoPure_Previews: PreviewProvider {
    static var previews: some View {
        Screen9PhotoPure(didTapNextAction: {_ in })
    }
}
