//
//  AuthRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인, 토큰갱신
enum AuthRouter: URLRequestConvertible {
    
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case tokenRefresh
    case user
    
    // 서버 기본 URL
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    // 서버 라우터 주소 끝 부분
    var endPoint: String {
        switch self {
        case .register:
            return "member/signUp"
        case .login:
            return "member/signIn"
        case .tokenRefresh:
            return "member/refresh"
        case .user:
            return "member/currentUser"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register, .tokenRefresh: return .post
        default: return .get
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            return params
            
        case .register(let name, let email, let password):
            var params = Parameters()
            params["name"] = name
            params["email"] = email
            params["password"] = password
            return params
        case .tokenRefresh:
            var params = Parameters()
            let tokenData = UserDefaultsManager.shared.getTokens()
            params["refresh_token"] = tokenData.refreshToken
            return params
        default:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        request.method = method
        if method != .get{
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        return request
    }
    
    
}
