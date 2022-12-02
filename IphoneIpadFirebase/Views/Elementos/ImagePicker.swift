//
//  ImagePicker.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 30/11/22.
//

import Foundation
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(conexion: self)
    }
    
    @Binding var show : Bool
    @Binding var image : Data
    var source : UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.allowsEditing = true
        controller.delegate = context.coordinator //as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var conexion : ImagePicker
        init(conexion : ImagePicker){
            self.conexion = conexion
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Se canceló")
            self.conexion.show.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.100)
            self.conexion.image = data!
            self.conexion.show.toggle()
        }
    }
    
}
