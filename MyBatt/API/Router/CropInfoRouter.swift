//
//  CropInfoRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/25.
//

import Foundation
import Alamofire

enum CropInfoRouter: URLRequestConvertible {
    case SickDetail
    case SickList
    case NoticeList
    case PsisList(cropName:String,diseaseWeedName:String,displayCount:String,startPoint:String)
    case PsisDetail(pestiCode:String,diseaseUseSeq:String,displayCount:String,startPoint:String)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self{
        case .SickDetail:
            return "crop/sickDetail"
        case .SickList:
            return "crop/sickList"
        case .NoticeList:
            return "crop/noticeList"
        case .PsisList:
            return "crop/psisList"
        case .PsisDetail:
            return "crop/psisDetail"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .PsisDetail(pestiCode: code, diseaseUseSeq: seq, displayCount: cnt, startPoint: startPoint):
            return Parameters()
        case let .PsisList(cropName: cropName, diseaseWeedName: diseaseWeedName, displayCount: cnt, startPoint: startPoint):
            return Parameters()
        case let .NoticeList:
            return Parameters()
        case let .SickDetail:
            return Parameters()
        case let .SickList:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        return request
    }
    
    
}
