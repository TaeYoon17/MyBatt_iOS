//
//  CropInfoRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/25.
//

import Foundation
import Alamofire

enum CropInfoRouter: URLRequestConvertible {
    case SickDetail(sickKey:String)
    case SickList(cropName:String,sickNameKor:String,displayCount:Int,startPoint:Int)
    case NoticeList
    case PsisList(cropName:String,diseaseWeedName:String,displayCount:String,startPoint:String)
    case PsisDetail(pestiCode:String,diseaseUseSeq:String,displayCount:String,startPoint:String)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    func changeKorean(str: String)->String{
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    var endPoint: String {
        switch self{
        case .SickDetail(let sickKey):
            return "crop/sickDetail?sickKey=\(sickKey)"
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
        case .PsisList, .PsisDetail: return .post
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
        case let .SickList(cropName: cropName, sickNameKor: sickNameKor, displayCount: displayCnt, startPoint: startPt):
            var params = Parameters()
            params["cropName"] = cropName
            params["sickNameKor"] = sickNameKor
            params["displayCount"] = String(displayCnt)
            params["startPoint"] = String(startPt)
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
extension CropInfoRouter{
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
    var postRequest:URLRequest{
        let url = baseURL.appendingPathComponent(endPoint)
        guard var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: true) else {return URLRequest(url: url)}
        urlComponents.queryItems = self.parameters.map { key, value in
            URLQueryItem(name: key, value: value as? String ?? "")
        }
        var request = URLRequest(url: urlComponents.url!)
        request.method = self.method
        return request
    }
}
