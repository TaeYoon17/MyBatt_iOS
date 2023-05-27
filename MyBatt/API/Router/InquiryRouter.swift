//
//  InquiryRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import Foundation
import Alamofire
enum InquiryRouter: URLRequestConvertible {
    case list
    case detailed
    case delete(inquiryId: Int)
    case register(diagnosisId: Int,title: String,contents:String)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    var endPoint: String {
        switch self{
        case .delete(let id):
            return "crop/inquiry/\(id)"
        case .detailed:
            return "crop/inquiry/delete"
        case .list:
            return "crop/inquiry/list"
        case .register:
            return "crop/inquiry/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        case .delete:
            return .delete
        default: return .get
        }
    }
    
    var parameters: Parameters{
        switch self {
        case .delete,.list,.detailed:
            return Parameters()
        case let .register(diagnosisId: id,title: title,contents:contents):
            var params = Parameters()
            params["diagnosisRecordId"] = id
            params["title"] = title
            params["contents"] = contents
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        return request
    }
    
    
}
