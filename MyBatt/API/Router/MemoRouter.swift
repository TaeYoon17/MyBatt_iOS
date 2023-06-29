//
//  MemoRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import Foundation

import Foundation
import Alamofire

enum MemoRouter: URLRequestConvertible {
    case List(diagnosisRecordID: Int)
    case Add(diagnosisRecordID: Int,contents: String)
    case Update(memoID: Int,contents: String)
    case Detail(memoID: Int)
    case Delete(memoID: Int)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    func changeKorean(str: String)->String{
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    var endPoint: String {
        switch self{
        case .List:
            return "crop/manage/read/list"
        case .Add:
            return "crop/manage/create"
        case .Update:
            return "crop/manage/update"
        case .Delete:
            return "crop/manage/delete"
        case .Detail:
            return "crop/manage/read/detail"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .List,.Detail:
            return .get
        case .Add:
            return .post
        case .Update:
            return .post
        case .Delete:
            return .delete
        }
    }
    
    var parameters: Parameters{
        var params = Parameters()
        switch self {
        case .List(diagnosisRecordID: let id):
            params["diagnosisRecordId"] = String(id)
            return params
        case let .Add(diagnosisRecordID: id, contents: contents):
            params["contents"] = contents
            params["diagnosisRecordId"] = String(id)
            return params
        case let .Update(memoID: id, contents: contents):
            params["myCropId"] = String(id)
            params["contents"] = contents
            return params
        case .Detail(memoID: let id):
            params["myCropId"] = String(id)
            return params
        case .Delete(memoID: let id):
            params["myCropId"] = String(id)
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self.method{
//        case .post:
//            return self.postRequest
        default:
            return self.getRequest
        }
        
//        switch self{
//        case .List:
//            return self.getRequest
//        default: break
//        }
//        switch self.method{
//        case .get:
//            return self.getRequest
//        case .post:
//            return self.postRequest
//        default:
//            let url = baseURL.appendingPathComponent(endPoint)
//            var request = URLRequest(url: url)
//            request.method = self.method
//            return request
//        }
    }
    
}
//MARK: -- Method 방법마다의 URLRequest 만들기
extension MemoRouter{
    var getRequest:URLRequest{// 파라미터들을 쿼리로 보내는 계산 속성
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
