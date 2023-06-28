//
//  MapFilterVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import Foundation
import SwiftUI
import Alamofire
import Combine


final class MapFilterVM:ObservableObject{
    static let accRange: AccRange = (start:50,end:95)
    // 여기 나중에 true로 수정해야함!
    //  전송하는 데이터
    @Published var crops: [MapSheetCrop] = []
    @Published var durationType: DurationType = .week
    @Published var selectDate:Date = Date.weekAgo
    // 작물 종류 - 진단 타입 - 계수
    @Published var mapDiseaseCnt: [CropType:[DiagnosisType:Int]] = [:]
    var subscription = Set<AnyCancellable>()
    var dateRange: ClosedRange<Date>{
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -3, to: currentDate)!
        let endDate = calendar.date(byAdding: .day, value: 0, to: currentDate)!
        return startDate...endDate
    }
    deinit{
        subscription.forEach { can in
            can.cancel()
        }
    }
    func makeDiseaseCnt(diseaseResult: MapDiseaseResult?){
        var mapDiseaseCnt: [CropType:[DiagnosisType:Int]] = [
            .Lettuce: [
                .LettuceDownyMildew : 0,
                .LettuceMycosis : 0
            ],
            .Pepper:[
                .PepperSpot: 0,
                .PepperMildMotle: 0
            ],
            .StrawBerry:[
                .StrawberryPowderyMildew: 0,
                .StrawberryGrayMold:0,
            ],
            .Tomato:[
                .TomatoLeafFungus:0,
                .TomatoYellowLeafRoll:0
            ]
        ]
        diseaseResult?.results.forEach({ (key,val) in
            val.forEach { item in
                mapDiseaseCnt[key]![item.diseaseCode]? += 1
            }
        })
        DispatchQueue.main.async {
            self.mapDiseaseCnt = mapDiseaseCnt
        }
    }
}
//MARK: -- 필터링 값 전달자
extension MapFilterVM{
    func addSubscribers(mainVM: MapMainVM){
        self.crops = mainVM.crops
        self.selectDate = mainVM.selectDate
        self.durationType = mainVM.durationType
        self.$crops.sink {val in
            mainVM.crops = val
        }.store(in: &subscription)
        self.$selectDate.sink { val in
            mainVM.selectDate = val
        }.store(in: &subscription)
        self.$durationType.sink { type in
            mainVM.durationType = type
        }.store(in: &subscription)
    }
}
