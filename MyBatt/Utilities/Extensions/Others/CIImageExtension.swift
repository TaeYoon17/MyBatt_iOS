//
//  CIImage.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import Foundation
import CoreImage
import SwiftUI
extension CIImage{
    var image: Image?{
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {return nil}
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
    var cropImage: CIImage{
        let width = self.extent.width
        return self.cropped(to: CGRect(x: 0, y: 0, width: width,height:width))
    }
}
