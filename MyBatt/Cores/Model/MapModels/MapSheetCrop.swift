//
//  MapSheetCrop.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import Foundation
import SwiftUI
// 고 - 딸 - 상 - 토
struct MapSheetCrop:Codable,Equatable,Identifiable{
    var id = UUID()
    let cropType: DiagCropType.RawValue
    var cropKorean: String{
        DiagCrop.koreanTable[DiagCropType(rawValue: cropType) ?? .none] ?? "아직 이름 없음"
    }
    var cropColor: Color{
        DiagCrop.colorTable[DiagCropType(rawValue: cropType) ?? .none] ?? .black
    }
    var accuracy: Double
    var isOn: Bool
    enum CodingKeys: String, CodingKey {
        case cropType
        case accuracy
        case isOn
    }
}
