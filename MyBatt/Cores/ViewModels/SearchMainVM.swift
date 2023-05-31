//
//  SearchMainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/26.
//

import Foundation
import Alamofire
import Combine
final class SeaerchMainVM: ObservableObject{
    @Published var searchText = ""
    @Published var data:[Item] = dummies()
    @Published var searchResults: [Item] = []
    @Published var sickListResponse:SickListResponse?
    var subscription = Set<AnyCancellable>()
    func requestSickList(cropName:String?,sickNameKor:String?,displayCount: Int?,startPoint:Int?){
        let storedTokenData = UserDefaultsManager.shared.getTokens()

        let credential = OAuthCredential(accessToken: storedTokenData.accessToken,
                                         refreshToken: storedTokenData.refreshToken,
                                         expiration: Date(timeIntervalSinceNow: 60 * 60))
        // Create the interceptor
        let authenticator = OAuthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)

        ApiClient.shared.session.request(CropInfoRouter.SickList(cropName: cropName ?? "", sickNameKor: sickNameKor ?? "", displayCount: 10, startPoint: 1),interceptor: authInterceptor)
//            .publishString()
//            .sink { response in
//                print(String(data: response.data!, encoding: .utf8))
//            }.cancel()
            .publishDecodable(type: ResponseWrapper<SickListResponse>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: { output in
                print(output.data?.sickList)
            }).store(in: &subscription)
    }
}
