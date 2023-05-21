//
//  BaseInterceptor.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import Foundation
import Alamofire

final class BaseInterceptor: RequestInterceptor {
    
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        
        // 헤더 부분 넣어주기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        completion(.success(request))
    }
}
// Token Interceptor -> 토큰 만료용 인터셉터 해야할 수도?
