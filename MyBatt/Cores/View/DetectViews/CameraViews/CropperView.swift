//
//  CropperView.swift
//  ImagePickerSwiftUI
//
//  Created by 김태윤 on 2023/05/22.
//

import CropViewController
import UIKit
import SwiftUI

struct CropperView: UIViewControllerRepresentable{
    @Binding var image: Image?
    @Binding var uiimage: UIImage?
    @EnvironmentObject var vm: AlbumPickerVM
    func makeUIViewController(context: Context) -> CropViewController {
        let vc = CropViewController(croppingStyle: .default, image: uiimage ?? UIImage())
                vc.toolbar.cancelTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                vc.toolbar.doneTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        vc.aspectRatioPreset = .presetSquare
        vc.cropView.backgroundColor = .black
        vc.toolbarPosition = .top
        vc.aspectRatioLockEnabled = true
        vc.aspectRatioPickerButtonHidden = true
        vc.resetButtonHidden = true
        vc.rotateButtonsHidden = true
        vc.doneButtonTitle = "완료 "
        vc.doneButtonColor = .systemBlue
        vc.cancelButtonTitle = " 취소"
        
        vc.cancelButtonColor = UIColor(named: "AccentColor")
        vc.delegate = context.coordinator
        return vc
    }
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image,uiImage: $vm.uiimage)
    }
    final class Coordinator: NSObject, CropViewControllerDelegate{
        @Binding var image: Image?
        @Binding var uiImage: UIImage?
        init(image: Binding<Image?>,uiImage: Binding<UIImage?>) {
            self._image = image
            self._uiImage = uiImage
//            self._showImagePicker = showImagePicker
        }
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            if cancelled{
                self.image = nil
                self.uiImage = nil
                cropViewController.dismiss(animated: true)
            }
        }
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            print("Did Crop")
            DispatchQueue.main.async {
                self.uiImage = image
                self.image = Image(uiImage: image)
                cropViewController.dismiss(animated: true)
            }
        }
    }
}
