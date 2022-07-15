//
//  ImagePicker.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-10.
//

import Foundation
import SwiftUI
import PhotosUI
import os

struct ImagePicker: UIViewControllerRepresentable {
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ImagePicker.self)
    )
//    let logger = Logger()
    
    @Binding var image:UIImage?
    @Binding var showPicker: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        var parent : ImagePicker
        
        init(parent1: ImagePicker){
            parent = parent1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            parent.showPicker.toggle()
            
            for img in results{
                if img.itemProvider.canLoadObject(ofClass: UIImage.self){
                    img.itemProvider.loadObject(ofClass: UIImage.self){
                        (image, err) in
                        
                        guard let image1 = image else {
                            self.parent.logger.log("Error in loading image.")
                            return
                        }
                        self.parent.image = image1 as? UIImage
                        
                    }
                } else {
                    self.parent.logger.log("Error in loading image.")
                }
            }
        }
    }
}
