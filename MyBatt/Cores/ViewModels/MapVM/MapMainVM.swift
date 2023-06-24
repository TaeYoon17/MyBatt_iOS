//
//  MapMainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import Foundation
import Combine
import Alamofire
typealias AccRange = (start:Double,end:Double)
final class MapMainVM: ObservableObject{
    static let accRange: AccRange = (start:50,end:95)
    @Published var isFilter = false
    @Published var isPresent = false
    @Published var center: Geo = Geo(0,0)
    @Published var isGPSOn = false
    @Published var locationName = ""
    @Published var diseaseResult: MapDiseaseResult?
    @Published var crops: [MapSheetCrop] = CropType.allCases.map { type in
        MapSheetCrop(cropType: type.rawValue, accuracy: MapMainVM.accRange.start > 80.0 ? MapMainVM.accRange.start : 80,isOn: false)
    }
    @Published var durationType: DurationType = .week
    @Published var selectDate:Date = Date.weekAgo
    // sheetvm에서 mapvm으로 전달해줌 -> 단방향
    var passthroughCenter = PassthroughSubject<Geo,Never>()
    var passthroughIsGPSOn = PassthroughSubject<Bool,Never>()
    var passthroughDiseaseResult = PassthroughSubject<MapDiseaseResult?,Never>()
    var subscription = Set<AnyCancellable>()
    
    init(){
        addSubscriber()
    }
    
    func addSubscriber(){
        self.$crops.sink { [weak self] _ in
            self?.requestNearDisease()
        }.store(in: &subscription)
        self.$selectDate.sink{ [weak self] _ in
            self?.requestNearDisease()
        }.store(in: &subscription)
    }
    private func requestNearDisease(){
        print("requestNearDisease called!! \(center)")
        let cropps = crops.filter { crop in
            if let last = crops.last{ return crop != last }else{ return true }
        }
        ApiClient.shared.session.request(MapRouter
            .nearDisease(geo: center, mapSheetCropList: cropps, date: selectDate)
                                         ,interceptor: AuthAuthenticator.getAuthInterceptor)
        .publishDecodable(type: ResponseWrapper<[MapDiseaseResponse]>.self)
        .value()
        .sink { completion in
            switch completion{
            case .finished:
                print("requestNearDisease 가져오기 성공")
            case .failure(let error):
                print("requestNearDisease 가져오기 실패 \(error.localizedDescription)")
            }
        } receiveValue: {[weak self] output in
            if let nullableData: [MapDiseaseResponse] = output.data{
                print(nullableData)
                self?.diseaseResult = self?.makeDiseaseResult(data: nullableData.filter { response in
                    let type:DiagnosisType = DiagnosisType(rawValue: response.diseaseCode ?? -1) ?? .none
                    switch type{
                    case .none,.LettuceNormal,.PepperNormal,.TomatoNormal,.StrawberryNormal: return false
                    default: return true
                    }
                })
                self?.passthroughDiseaseResult.send(self?.diseaseResult)
            }else{
                print("내부에 데이터 없음!!")
            }
        }.store(in: &subscription)
    }
    private func makeDiseaseResult(data: [MapDiseaseResponse])->MapDiseaseResult{
        var returnVal: [CropType:[MapItem]] = CropType.allCases.reduce(into: [:]) { partialResult, type in
            if type != .none { partialResult[type] = [] }
        }
        data.forEach { res in
            guard let cropType:CropType = CropType(rawValue: res.diagnosisRecord.cropType ) else {return}
            guard let diseaseCode:DiagnosisType = DiagnosisType(rawValue: res.diseaseCode ?? -2) else {return}
            let geo = Geo(res.diagnosisRecord.userLatitude,res.diagnosisRecord.userLongitude)
            returnVal[cropType]?.append(MapItem(geo: geo, cropType: cropType, diseaseCode: diseaseCode))
        }
        return MapDiseaseResult(results: returnVal)
    }
}

