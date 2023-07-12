//
//  CropModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/17.
//

import Foundation
import SwiftUI
enum DiagCropType:Int,CaseIterable{
    case Pepper = 0
    case Lettuce = 2
    case StrawBerry = 1
    case Tomato = 3
    case none = -1
}
struct DiagCrop{
    static let koreanTable:[DiagCropType:String] = [.Lettuce:"상추",.Pepper:"고추",.StrawBerry:"딸기",.Tomato:"토마토",.none:"진단 실패"]
    static let iconTable:[DiagCropType:String] = [.Lettuce:"🥬",.Pepper:"🌶️",.StrawBerry:"🍓",.Tomato:"🍅"]
    static var allCrops:[DiagCropType]{ DiagCropType.allCases }
    static let colorTable:[DiagCropType:Color] = [.Lettuce: Color.yellow,.Pepper: Color.blue,.StrawBerry: Color.red,.Tomato: Color.orange]
    static let diseaseMatchTable:[DiagCropType:[DiagDiseaseType]] = [
        .Lettuce: [ .LettuceDownyMildew, .LettuceMycosis ],
        .Pepper:[ .PepperSpot, .PepperMildMotle ],
        .StrawBerry:[ .StrawberryPowderyMildew, .StrawberryGrayMold],
        .Tomato:[ .TomatoLeafFungus,.TomatoYellowLeafRoll ]
    ]
}
