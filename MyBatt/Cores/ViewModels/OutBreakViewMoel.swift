//
//  OutBreakViewMoel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
import Alamofire
final class OutBreakViewMoel: ObservableObject{
    var subscription = Set<AnyCancellable>()
    @Published var outbreakModel: OutbreakModel?
    init(){
    }
    deinit{
        subscription.forEach{
            $0.cancel()
        }
    }
    func downloadData(){
        
    }
    func fetchOutbreakList(){
                print("AuthApiService - fetchCurrentUserInfo() called")
                let storedTokenData = UserDefaultsManager.shared.getTokens()
        
                let credential = OAuthCredential(accessToken: storedTokenData.accessToken,
                                                 refreshToken: storedTokenData.refreshToken,
                                                 expiration: Date(timeIntervalSinceNow: 60 * 60))
        
                // Create the interceptor
                let authenticator = OAuthAuthenticator()
                let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                credential: credential)
    
            ApiClient.shared.session
            .request(CropInfoRouter.NoticeList, interceptor: authInterceptor)
                    .publishDecodable(type: ResponseWrapper<OutbreakModel>.self)

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
                        self.outbreakModel = output.data
                    }).store(in: &subscription)
    }
}
