//
//  MapRouter.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import Foundation
import Alamofire

enum MapRouter: URLRequestConvertible {
    case nearDisease(geo: Geo,mapSheetCropList: [MapSheetCrop],date: Date)
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    var endPoint: String {
        switch self{
        case .nearDisease:
            return "crop/nearDisease"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .nearDisease(geo: geo, mapSheetCropList: mapSheetCropList, date: date):
            var parameters = Parameters()
            parameters["latitude"] = geo.latitude
            parameters["longitude"] = geo.longtitude
            parameters["date"] = date.ISO8601Format()
            parameters["mapSheepCropList"] = try! JSONEncoder().encode(mapSheetCropList)
            return parameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        return request
    }
    
    
}
