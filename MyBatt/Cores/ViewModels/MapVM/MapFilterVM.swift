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
    @Published var mapDiseaseCnt: [DiagCropType:[DiagDiseaseType:Int]] = [:]
    var subscription = Set<AnyCancellable>()
    var isInit = true
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
        print("MapFilterVM 메모리 해제")
    }
    func makeDiseaseCnt(diseaseResult: MapDiseaseResult?){
        var mapDiseaseCnt:[DiagCropType:[DiagDiseaseType:Int]] = DiagCrop.diseaseMatchTable.reduce(into: [:]) {
            $0[$1.key] = $1.value.reduce(into: [:], { $0[$1] = 0 })
        }
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
        self.$crops.sink {[weak self]val in
            guard self?.isInit == false else { return }
            mainVM.crops = val
        }.store(in: &subscription)
        self.$selectDate.sink {[weak self] val in
            guard self?.isInit == false else { return }
            mainVM.selectDate = val
        }.store(in: &subscription)
        self.$durationType.sink {[weak self] val in
            guard self?.isInit == false else { return }
            mainVM.durationType = val
        }.store(in: &subscription)
        self.isInit = false
    }
}
