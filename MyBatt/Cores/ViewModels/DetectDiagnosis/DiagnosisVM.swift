//
//  DiagnosisViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//
import Foundation
import SwiftUI
import Combine
import Alamofire
final class DiagnosisVM:ObservableObject{
    private var subscription = Set<AnyCancellable>()
    lazy var requestInfoSuccess = PassthroughSubject<DiseaseDetail,Never>()
    var tempInfoSuccess = PassthroughSubject<(),Never>()
    deinit{
        subscription.forEach { ca in
            ca.cancel()
        }
    }
    func tempInfo(){
        self.tempInfoSuccess.send()
    }
    func requestInfo(key: String){
                print("DiagnosisVM - requestInfo() called")
                let storedTokenData = UserDefaultsManager.shared.getTokens()
        
                let credential = OAuthCredential(accessToken: storedTokenData.accessToken,
                                                 refreshToken: storedTokenData.refreshToken,
                                                 expiration: Date(timeIntervalSinceNow: 60 * 60))
                // Create the interceptor
                let authenticator = OAuthAuthenticator()
                let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                credential: credential)
    
            ApiClient.shared.session
            .request(CropInfoRouter.SickDetail(sickKey: key), interceptor: authInterceptor)
                    .publishDecodable(type: ResponseWrapper<DiseaseDetail>.self)
                    .value()
                    .sink(receiveCompletion: { completion in
                        switch completion{
                        case .finished:
                            print("가져오기 성공")
                        case .failure(let error):
                            print("가져오기 실패")
                            print(error.localizedDescription)
                        }
                    }, receiveValue: {[weak self] output in
                        if let output:DiseaseDetail = output.data{
                            self?.requestInfoSuccess.send(output)
                        }else{
                            print("병해 디테일 정보 가져오기 실패함")
                        }
                    }).store(in: &subscription)
    }
}
