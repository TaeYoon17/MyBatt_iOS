//
//  MapSheetVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import Foundation
import SwiftUI
import Alamofire
import Combine


typealias AccRange = (start:Double,end:Double)
final class MapSheetVM:ObservableObject{
    static let accRange: AccRange = (start:85,end:95)
    @Published var locationName: String? = ""
    @Published var crops: [MapSheetCrop]
    @Published var center: Geo = (37.661497,126.884958)
    // 여기 나중에 true로 수정해야함!
    @Published var isGPSOn: Bool? = false
    @Published var durationType: DurationType = .week
    @Published var selectDate:Date = Date.weekAgo
    @Published var mapDiseaseResponse: [MapDiseaseResponse]?
    @Published var mapDiseaseResult:MapDiseaseResult?
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
    var mapQueryDataService: MapQueryDataService = MapQueryDataService()
    init(){
        crops = CropType.allCases.map { type in
            MapSheetCrop(cropType: type.rawValue, accuracy: Self.accRange.start > 80.0 ? Self.accRange.start : 80,isOn: false)
        }
        addSubscribers()
    }
    deinit{
        subscription.forEach { can in
            can.cancel()
        }
    }
    
    
    func requestNearDisease(){
        print("requestNearDisease called!! \(center)")
        let cropps = crops.filter { crop in
            if let last = crops.last{
                return crop != last
            }else{
                return true
            }
        }
        print(cropps)
        let storedTokenData = UserDefaultsManager.shared.getTokens()
        let credential = OAuthCredential(accessToken: storedTokenData.accessToken,
                                         refreshToken: storedTokenData.refreshToken,
                                         expiration: Date(timeIntervalSinceNow: 60 * 60))
        // Create the interceptor
        let authenticator = OAuthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)
        ApiClient.shared.session.request(MapRouter
            .nearDisease(geo: center, mapSheetCropList: cropps, date: selectDate)
                                         ,interceptor: authInterceptor)
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
            if let nullableData = output.data{
                print(nullableData)
                self?.mapDiseaseResult = self?.makeDiseaseResult(data: nullableData)
//                print("self?.mapDiseaseResult 값 생성!!")
                self?.makeDiseaseCnt()
            }else{
                print("내부에 데이터 없음!!")
            }
        }.store(in: &subscription)
    }
    private func makeDiseaseCnt(){
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
        DispatchQueue.main.async {
            self.mapDiseaseResult?.results.forEach({ (key,val) in
                val.forEach { item in
                    mapDiseaseCnt[key]![item.diseaseCode]? += 1
                }
            })
            self.mapDiseaseCnt = mapDiseaseCnt
        }
    }
    
    private func makeDiseaseResult(data: [MapDiseaseResponse])->MapDiseaseResult{
        var returnVal: [CropType:[MapItem]] = CropType.allCases.reduce(into: [:]) { partialResult, type in
            if type != .none {
                partialResult[type] = []
            }
        }
        data.forEach { res in
            guard let cropType:CropType = CropType(rawValue: res.diagnosisRecord.cropType ) else {return}
            guard let diseaseCode:DiagnosisType = DiagnosisType(rawValue: res.diseaseCode ?? -2) else {return}
            let geo = Geo(res.diagnosisRecord.userLatitude,res.diagnosisRecord.userLongitude)
            returnVal[cropType]?.append(MapItem(cropType: cropType, geo: geo, diseaseCode: diseaseCode))
        }
        return MapDiseaseResult(results: returnVal)
    }
}
//MARK: -- 검색어 좌표 변환
extension MapSheetVM{
    func requestLocation(query:String){
        guard query != "" else { return }
        mapQueryDataService.getMapCoordinate(query: query)
    }
}

extension MapSheetVM{
    private func addSubscribers(){ // 의존성 주입
        let myLocationPublisher: Published<Geo>.Publisher = self.$center
        myLocationPublisher.sink{[weak self] output in
            self?.requestNearDisease()
        }
        .store(in: &subscription)
        let cropFilterPublisher: Published<[MapSheetCrop]>.Publisher = self.$crops
        cropFilterPublisher.sink { [weak self] output in
            print("변화가 일어남")
            self?.requestNearDisease()
        }.store(in: &subscription)
        let selectDatePublisher: Published<Date>.Publisher = self.$selectDate
        selectDatePublisher.sink { [weak self] output in
//            print("selectDatePublisher 변화가 일어남")
            print(output.ISO8601Format())
            self?.requestNearDisease()
        }.store(in: &subscription)
        let mapQueryPublisher: Published<MapQueryModel?>.Publisher = self.mapQueryDataService.$queryResult
        mapQueryPublisher.sink { [weak self] output in
            if let output = output{
                if !output.documents!.isEmpty{
                    self?.center = Geo(latitude:Double(output.documents![0].y!)!,
                                       longtitude:Double(output.documents![0].x!)!)
                    
                }
            }
        }.store(in: &subscription)
    }
}

