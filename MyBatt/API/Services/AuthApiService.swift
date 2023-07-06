//
//  AuthApiService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/23.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum AuthApiService {
    // 회원가입
    static func register(name: String, email: String, password: String) -> AnyPublisher<RegisterData?, AFError>{
        print("AuthApiService - register() called")
        return ApiClient.shared.session
            .request(AuthRouter.register(name: name, email: email, password: password))
            .publishDecodable(type: RegisterResponse.self)
            .value()
            .map{ receivedValue in
                // 받은 토큰 정보 어딘가에 영구 저장 - 회원가입에서 하지 않음
                // userdefaults, keychain
//                UserDefaultsManager.shared.setTokens(accessToken: receivedValue.token.accessToken,
//                                                     refreshToken: receivedValue.token.refreshToken)
                return receivedValue.data
            }.eraseToAnyPublisher()
    }
    
    // 로그인
    static func login(email: String, password: String) -> AnyPublisher<LogInResponse, AFError>{
        print("AuthApiService - register() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.login(email: email, password: password))
            .publishDecodable(type: LogInResponse.self)
            .value()
            .map{ receivedValue in
                // 받은 토큰 정보 어딘가에 영구 저장
                // userdefaults, keychain
                UserDefaultsManager.shared.setTokens(accessToken: receivedValue.accessToken,
                                                     refreshToken: receivedValue.refreshToken)
                return receivedValue
            }.eraseToAnyPublisher()
    }
    // 첫 로그인 상황 체크
    static func tokenCheck()->AnyPublisher<ResponseWrapper<UM>, AFError>{
        let userToken = UserDefaultsManager.shared.getTokens()
        print(userToken)
        let credential = OAuthCredential(accessToken: userToken.accessToken,
                                         refreshToken: userToken.refreshToken,
                                         expiration: Date(timeIntervalSinceNow: 60 * 60))
        let authenticator = OAuthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)
        return ApiClient.shared.session.request(AuthRouter.user,interceptor: authInterceptor)
            .publishDecodable(type:ResponseWrapper<UM>.self)
            .value()
    }
}
