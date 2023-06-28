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
    @Published var isPresent = false
    @Published var center: Geo = Geo(0,0)
    @Published var isGPSOn = false
    @Published var locationName = ""
    @Published var nearDiseaseItems: [CropType:[MapDiseaseResponse]]?
    @Published var tappedItem: (any Markerable)? = nil
    @Published var crops: [MapSheetCrop] = CropType.allCases.map { type in
        MapSheetCrop(cropType: type.rawValue, accuracy: MapMainVM.accRange.start > 80.0 ? MapMainVM.accRange.start : 80,isOn: false)
    }
    @Published var durationType: DurationType = .week
    @Published var selectDate:Date = Date.weekAgo
    // sheetvm에서 mapvm으로 전달해줌 -> 단방향
    var passthroughCenter = PassthroughSubject<Geo,Never>()
    var passthroughIsGPSOn = PassthroughSubject<Bool,Never>()
    var passthroughNearDiseaseItems = PassthroughSubject<[CropType:[MapDiseaseResponse]]?,Never>()
    var subscription = Set<AnyCancellable>()
    
    init(){
        addSubscriber()
    }
    
    func addSubscriber(){
        self.$center.delay(for: 0.2, scheduler: DispatchQueue.global())
            .sink { [weak self] _ in
            self?.requestNearDisease()
        }.store(in: &subscription)
        self.$crops.delay(for: 0.2, scheduler: DispatchQueue.global())
            .sink { [weak self] _ in self?.requestNearDisease()}
            .store(in: &subscription)
        self.$selectDate.delay(for: 0.2, scheduler: DispatchQueue.global())
            .sink{ [weak self] _ in self?.requestNearDisease()}
            .store(in: &subscription)
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
                let nearDiseaseItems = self?.makeDiseaseResult(nullableData.filter { response in
                    let diseasetype:DiagnosisType = DiagnosisType(rawValue: response.diseaseCode ?? -1) ?? .none
                    let cropType: CropType = CropType(rawValue:response.diagnosisRecord.cropType) ?? .none
                    switch (diseasetype, cropType) {
                    case (.none,_), (.LettuceNormal,_), (.PepperNormal,_), (.TomatoNormal,_) ,(.StrawberryNormal,_):
                        return false
                    case (.TomatoLeafFungus, .Tomato), (.TomatoYellowLeafRoll, .Tomato),
                         (.LettuceMycosis, .Lettuce), (.LettuceDownyMildew, .Lettuce),
                         (.StrawberryGrayMold, .StrawBerry), (.StrawberryPowderyMildew, .StrawBerry),
                         (.PepperSpot, .Pepper), (.PepperMildMotle, .Pepper):
                        return true
                    default:
                        return false
                    }
                })
                self?.passthroughNearDiseaseItems.send(nearDiseaseItems)
            }else{
                print("내부에 데이터 없음!!")
            }
        }.store(in: &subscription)
    }
    
    private func makeDiseaseResult(_ responses:[MapDiseaseResponse]) -> [CropType:[MapDiseaseResponse]]{
        responses.reduce(into: [:]) { partialResult, response in
            let type: CropType = CropType(rawValue: response.diagnosisRecord.cropType) ?? .none
            if type != .none {
                if partialResult.keys.contains(type){
                    partialResult[type]?.append(response)
                }else{
                    partialResult[type] = [response]
                }
            }
        }
    }
    
    
    //MARK: -- 응답받은 주변 병해 정보를 맵 마커용 데이터로 바꿔주는 메서드
//    private func makeDiseaseResult(data: [MapDiseaseResponse])->MapDiseaseResult{
//        var returnVal: [CropType:[MapItem]] = CropType.allCases.reduce(into: [:]) { partialResult, type in
//            if type != .none { partialResult[type] = [] }
//        }
//        data.forEach { res in
//            guard let cropType:CropType = CropType(rawValue: res.diagnosisRecord.cropType ) else {return}
//            guard let diseaseCode:DiagnosisType = DiagnosisType(rawValue: res.diseaseCode ?? -2) else {return}
//            let geo = Geo(res.diagnosisRecord.userLatitude,res.diagnosisRecord.userLongitude)
//            returnVal[cropType]?.append(MapItem(id: res.id,geo: geo, cropType: cropType, diseaseCode: diseaseCode))
//        }
//        return MapDiseaseResult(results: returnVal)
//    }
}

