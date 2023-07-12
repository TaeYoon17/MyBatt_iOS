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
    @Published var nearDiseaseItems: [DiagCropType:[MapDiseaseResponse]]?
    @Published var tappedItem: (any Markerable)? = nil
    @Published var crops: [MapSheetCrop] = DiagCropType.allCases.map { type in
        MapSheetCrop(cropType: type.rawValue,
                     accuracy: MapMainVM.accRange.start > 80.0 ? MapMainVM.accRange.start : 80
                     ,isOn: false)
    }
    @Published var durationType: DurationType = .week
    @Published var selectDate:Date = Date.weekAgo
    // sheetvm에서 mapvm으로 전달해줌 -> 단방향
    var passthroughCenter = PassthroughSubject<Geo,Never>()
    var passthroughIsGPSOn = PassthroughSubject<Bool,Never>()
    var passthroughNearDiseaseItems = PassthroughSubject<[DiagCropType:[MapDiseaseResponse]]?,Never>()
    private var subscription = Set<AnyCancellable>()
    
    init(){ addSubscriber() }
    deinit{
        subscription.forEach{$0.cancel()}
        print("MapMainVM 메모리 해제")
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
            guard let self = self else { return }
            if let diseaseResponses: [MapDiseaseResponse] = output.data{
                print(diseaseResponses)
                let nearDiseaseItems = self.makeDiseaseResult(
                    diseaseResponses.filter { response in
                    let diseasetype = DiagDiseaseType(rawValue: response.diseaseCode ?? -1) ?? .none
                    let cropType = DiagCropType(rawValue:response.diagnosisRecord.cropType) ?? .none
                    return self.cropDiseaseMatchTable(diseasetype: diseasetype, cropType: cropType)
                })
                self.passthroughNearDiseaseItems.send(nearDiseaseItems)
            }else{
                print("내부에 데이터 없음!!")
            }
        }.store(in: &subscription)
    }
    private func makeDiseaseResult(_ responses:[MapDiseaseResponse]) -> [DiagCropType:[MapDiseaseResponse]]{
        responses.reduce(into: [:]) { partialResult, response in
            let type = DiagCropType(rawValue: response.diagnosisRecord.cropType) ?? .none
            guard type != .none else { return }
            if partialResult.keys.contains(type){
                partialResult[type]?.append(response)
            }else{
                partialResult[type] = [response]
            }
        }
    }
    
}

extension MapMainVM{
    private func cropDiseaseMatchTable(diseasetype:DiagDiseaseType,cropType:DiagCropType)->Bool{
        if let res = DiagCrop.diseaseMatchTable[cropType]?.contains(diseasetype), res == true{
            return true
        }else{
            return false
        }
    }
}
/// Legacy Code
//
//        switch (diseasetype, cropType) {
//        case (_,.none): return false
//        case (.none,_), (.LettuceNormal,_), (.PepperNormal,_), (.TomatoNormal,_) ,(.StrawberryNormal,_):
//            return false
//        case (.TomatoLeafFungus, .Tomato), (.TomatoYellowLeafRoll, .Tomato),
//            (.LettuceMycosis, .Lettuce), (.LettuceDownyMildew, .Lettuce),
//            (.StrawberryGrayMold, .StrawBerry), (.StrawberryPowderyMildew, .StrawBerry),
//            (.PepperSpot, .Pepper), (.PepperMildMotle, .Pepper):
//            return true
//        default:
//            return false
//        }
