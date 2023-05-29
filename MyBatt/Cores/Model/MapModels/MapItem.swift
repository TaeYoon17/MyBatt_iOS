//
//  MapItem.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/29.
//

import Foundation
struct MapItem:Equatable{
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        lhs.diseaseCode == rhs.diseaseCode && lhs.geo == rhs.geo
    }
    
    let cropType: CropType
    let geo: Geo
    let diseaseCode: DiagnosisType
    
}
