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
//    @Published var dates: [DurationType]
    @Published var isGPSOn: Bool? = true
    @Published var durationType: DurationType = .day
    @Published var selectDate:Date = Date()
    @Published var nearDiseaseList:[Any]? = nil
    var dateRange: ClosedRange<Date>{
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -3, to: currentDate)!
        let endDate = calendar.date(byAdding: .day, value: 0, to: currentDate)!
        return startDate...endDate
    }
    init(){
        crops = CropType.allCases.map { type in
            MapSheetCrop(cropType: type.rawValue, accuracy: Self.accRange.start > 80.0 ? Self.accRange.start : 80,isOn: false)
        }
    }
    func requestNearDisease(center: Geo){
        let storedTokenData = UserDefaultsManager.shared.getTokens()

        let credential = OAuthCredential(accessToken: storedTokenData.accessToken,
                                         refreshToken: storedTokenData.refreshToken,
                                         expiration: Date(timeIntervalSinceNow: 60 * 60))

        // Create the interceptor
        let authenticator = OAuthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)
        ApiClient.shared.session.request(MapRouter
            .nearDisease(geo: center, mapSheetCropList: crops, date: Date())
                                         ,interceptor: authInterceptor)
        .publishDecodable(type: ResponseWrapper<NearDiseasesResponse>.self)
        .value()
        .sink { completion in
            switch completion{
            case .finished:
                print("requestNearDisease 가져오기 성공")
            case .failure(let error):
                print("requestNearDisease 가져오기 실패 \(error.localizedDescription)")
            }
        } receiveValue: { output in
            print(output.code)
        }

    }
}


