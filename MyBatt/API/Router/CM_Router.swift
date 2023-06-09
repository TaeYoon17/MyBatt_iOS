//
//  CM_Router.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
import Alamofire

enum CM_Router: URLRequestConvertible {
    case CM_List
    case CM_GroupCreate(name: String)
    case CM_GroupDelete(id: Int)
    case CM_GroupUpdate(id: Int,newName: String,newMemo: String)
    case CM_GroupRecord(id: Int)
    case CM_GroupItemChange(groupId: Int,itemId: Int)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    func changeKorean(str: String)->String{
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    var endPoint: String {
        switch self{
        case .CM_List:
            return "crop/category/list"
        case .CM_GroupCreate:
            return "crop/category/create"
        case .CM_GroupDelete:
            return "crop/category/delete"
        case .CM_GroupUpdate:
            return "crop/category/update"
        case .CM_GroupRecord:
            return "crop/category/record"
        case .CM_GroupItemChange(groupId: _, itemId: let id):
            return "crop/diagnosisRecord/\(id)/category/update"
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .CM_List,.CM_GroupRecord:
            return .get
        case .CM_GroupCreate,.CM_GroupItemChange:
            return .post
        case .CM_GroupDelete:
            return .delete
        case .CM_GroupUpdate:
            return .put
        }
    }
    
    var parameters: Parameters{
        switch self {
        case .CM_List:
            var params = Parameters()
            return params
        case let .CM_GroupCreate(name: name):
            var params = Parameters()
            params["name"] = name
            return params
        case .CM_GroupDelete(id: let id):
            var params = Parameters()
            params["categoryId"] = String(id)
            return params
        case let .CM_GroupUpdate(id: id, newName: name, newMemo: memo):
            var params = Parameters()
            params["id"] = String(id)
            params["changeName"] = name
            params["changeMemo"] = memo
            return params
        case let .CM_GroupRecord(id: id):
            var params = Parameters()
            params["categoryId"] = String(id)
            return params
        case let .CM_GroupItemChange(groupId: id, itemId: _):
            var params = Parameters()
            params["categoryId"] = String(id)
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self{
        case .CM_GroupCreate,.CM_GroupDelete,.CM_GroupUpdate,.CM_GroupItemChange:
            return self.getRequest
        default: break
        }
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
extension CM_Router{
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
