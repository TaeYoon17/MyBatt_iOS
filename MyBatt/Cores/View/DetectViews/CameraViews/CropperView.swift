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
    @Binding var getImage: UIImage?
    func makeUIViewController(context: Context) -> CropViewController {
        let vc = CropViewController(croppingStyle: .default, image: getImage ?? UIImage())
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
        vc.cancelButtonTitle = " 취소"
        vc.delegate = context.coordinator
        return vc
    }
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image)
    }
    final class Coordinator: NSObject, CropViewControllerDelegate{
        @Binding var image: Image?
        init(image: Binding<Image?>) {
            self._image = image
//            self._showImagePicker = showImagePicker
        }
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true)
        }
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            cropViewController.dismiss(animated: true)
            print("Did Crop")
            self.image = Image(uiImage: image)
        }
    }
}
