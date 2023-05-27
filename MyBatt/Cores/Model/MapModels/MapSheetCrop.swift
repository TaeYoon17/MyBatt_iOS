//
//  MapSheetCrop.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import Foundation

struct MapSheetCrop:Codable,Equatable{
    let cropType: CropType.RawValue
    var cropKorean: String{
        Crop.koreanTable[CropType(rawValue: cropType) ?? .none] ?? "아직 이름 없음"
    }
    var accuracy: Double
    var isOn: Bool
    enum CodingKeys: String, CodingKey {
        case cropType
        case accuracy
        case isOn = "on"
    }
}
