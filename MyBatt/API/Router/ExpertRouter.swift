//
//  ExpertRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
import Alamofire

enum ExpertRouter: URLRequestConvertible {
    case Register(id: Int,title:String,contents: String)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    func changeKorean(str: String)->String{
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    var endPoint: String {
        switch self{
        case .Register:
            return "crop/inquiry/register"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .Register:
            return .post
        }
    }
    var parameters: Parameters{
        switch self {
        case let .Register(id: id, title: title, contents: contents):
            let params :Parameters = [
                "diagnosisRecordId":String(id),
                "title":title,
                "contents":contents
            ]
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self.method{
        case .get:
            return self.getRequest
        case .post:
            return self.postRequest
        default:
            let url = baseURL.appendingPathComponent(endPoint)
            var request = URLRequest(url: url)
            request.method = self.method
            return request
        }
    }
    
}
//MARK: -- Method 방법마다의 URLRequest 만들기
extension ExpertRouter{
    var getRequest:URLRequest{
        let url = baseURL.appendingPathComponent(endPoint)
        guard var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: true) else {return URLRequest(url: url)}
        urlComponents.queryItems = self.parameters.map { key, value in
            URLQueryItem(name: key, value: value as? String ?? "")
        }
        var request = URLRequest(url: urlComponents.url!)
        request.method = self.method
        return request
    }
    var postRequest: URLRequest{
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = self.method
        request.httpBody = try? JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }
}
