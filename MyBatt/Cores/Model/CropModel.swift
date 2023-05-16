//
//  CropModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/17.
//

import Foundation
enum CropType:Int,CaseIterable{
    case Pepper = 0
    case Lettuce = 1
    case StrawBerry = 2
    case Tomato = 3
}
struct Crop{
    static let koreanTable:[CropType:String] = [.Lettuce:"상추",.Pepper:"고추",.StrawBerry:"딸기",.Tomato:"토마토"]
    static let iconTable:[CropType:String] = [.Lettuce:"🥬",.Pepper:"🌶️",.StrawBerry:"🍓",.Tomato:"🍅"]
    static var allCrops:[CropType]{
        CropType.allCases
    }
}

