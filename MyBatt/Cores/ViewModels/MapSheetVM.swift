//
//  MapSheetVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import Foundation
import SwiftUI

struct MapSheetCrop{
    let cropType: CropType
    var cropKorean: String{
        Crop.koreanTable[cropType] ?? "아직 이름 없음"
    }
    var accuracy: Double
    var isOn: Bool
}
typealias AccRange = (start:Double,end:Double)
final class MapSheetVM:ObservableObject{
    static let accRange: AccRange = (start:85,end:95)
    @Published var locationName: String? = ""
    @Published var crops: [MapSheetCrop]
//    @Published var dates: [DurationType]
    @Published var isGPSOn: Bool? = true
    @Published var durationType: DurationType = .day
    @Published var selectDate:Date = Date()
    var dateRange: ClosedRange<Date>{
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -3, to: currentDate)!
        let endDate = calendar.date(byAdding: .day, value: 0, to: currentDate)!
        return startDate...endDate
    }
    init(){
        crops = CropType.allCases.map { type in
            MapSheetCrop(cropType: type, accuracy: Self.accRange.start > 80.0 ? Self.accRange.start : 80,isOn: false)
        }
    }
}


