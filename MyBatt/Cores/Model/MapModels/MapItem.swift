//
//  MapItem.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/29.
//

import Foundation
struct MapItem:Equatable,Markerable{
    var id = UUID()
    var geo: Geo
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
//        lhs.diseaseCode == rhs.diseaseCode && lhs.geo == rhs.geo
        lhs.id == rhs.id
    }
    let cropType: CropType
    let diseaseCode: DiagnosisType
}
