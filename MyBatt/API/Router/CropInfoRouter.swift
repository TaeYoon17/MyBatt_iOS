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
    case PsisList(cropName: String,diseaseWeedName:String,displayCount:Int,startPoint:Int)
    case NoticeList

    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    func changeKorean(str: String)->String{
        str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .PsisList:
            return .post
        default: return .get
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .NoticeList:
            return Parameters()
        case let .SickDetail(sickKey: keyy):
            var params = Parameters()
            params["sickKey"] = keyy
            return params
        case let .SickList(cropName: cropName, sickNameKor: sickNameKor, displayCount: displayCnt, startPoint: startPt):
            var params = Parameters()
            params["cropName"] = cropName
            params["sickNameKor"] = sickNameKor
            params["displayCount"] = String(displayCnt)
            params["startPoint"] = String(startPt)
            return params
        case let .PsisList(cropName: cropName, diseaseWeedName: diseaseName, displayCount: displayCnt, startPoint: startPt):
            var params = Parameters()
            params["cropName"] = cropName
            let newDiseaseName:String = diseaseName.replacingOccurrences(of: cropName, with: "").trimmingCharacters(in: .whitespaces)
            params["diseaseWeedName"] = newDiseaseName
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
    var postRequest: URLRequest{
        let url = baseURL.appendingPathComponent(endPoint)
//        guard var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: true) else {return URLRequest(url: url)}
//        urlComponents.queryItems = self.parameters.map { key, value in
//            URLQueryItem(name: key, value: value as? String ?? "")
//        }
        var request = URLRequest(url: url)
        request.method = self.method
        request.httpBody = try? JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }
}
