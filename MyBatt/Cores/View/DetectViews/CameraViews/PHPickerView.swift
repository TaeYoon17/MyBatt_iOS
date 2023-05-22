//
//  ImagePickerView.swift
//  ImagePickerSwiftUI
//
//  Created by 김태윤 on 2023/05/18.
//

import SwiftUI
import PhotosUI
import CropViewController
import UIKit


struct PHPickerView: UIViewControllerRepresentable{
    @Binding var uiimage: UIImage?
    //    @Binding var showImagePicker: Bool
    func makeUIViewController(context: Context) -> PHPickerViewController {
        lazy var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = context.coordinator
        picker.navigationItem.leftBarButtonItem?.title = "취소"
        picker.modalPresentationStyle = .currentContext
        picker.overrideUserInterfaceStyle = .dark
        return picker
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        self.uiimage = nil
        return Coordinator(image: $uiimage)
    }
    final class Coordinator: NSObject,PHPickerViewControllerDelegate{
        @Binding var uiimage: UIImage?
        //        @Binding var showImagePicker: Bool
        
        init(image: Binding<UIImage?>) {
            self._uiimage = image
            //            self._showImagePicker = showImagePicker
        }
//        canc
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider,itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image:UIImage = image as? UIImage{
                            self.uiimage = image
                        }
                    }
                }
            }else{
             print("No one picked!!")
            }
        }
        
        
        //        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //            if let uiImage = info[.originalImage] as? UIImage{
        //                image = Image(uiImage: uiImage)
        //            }
        //            showImagePicker = true
        //        }
        //        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //            showImagePicker = true
        //        }
    }
}

