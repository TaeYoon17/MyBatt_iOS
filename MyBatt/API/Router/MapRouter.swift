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
        default: return .post
        }
    }
    
    var parameters: Parameters{
        switch self {
        case let .nearDisease(geo: geo, mapSheetCropList: mapSheetCropList, date: date):
            var parameters = Parameters()
            parameters["latitude"] = geo.latitude
//            parameters["latitude"] = 37.661497
            parameters["longitude"] = geo.longtitude
//            parameters["longitude"] = 126.884958
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            parameters["date"] = dateFormatter.string(from: date)
            print("라우터에서 보낼 날짜: \(dateFormatter.string(from: date))")
//            parameters["mapSheepCropList"] = mapSheetCropList.map { crop in
//                ["cropType":crop.cropType,"accuracy":crop.accuracy,"isOn":crop.isOn] as [String : Any]
//            }
            parameters["mapSheepCropList"] =
            [
                ["cropType":0,"accuracy":mapSheetCropList[0].accuracy/100,"isOn":mapSheetCropList[0].isOn] as [String : Any],
                ["cropType":1,"accuracy":mapSheetCropList[1].accuracy/100,"isOn":mapSheetCropList[1].isOn] as [String : Any],
                ["cropType":2,"accuracy":mapSheetCropList[2].accuracy/100,"isOn":mapSheetCropList[2].isOn] as [String : Any],
                ["cropType":3,"accuracy":mapSheetCropList[3].accuracy/100,"isOn":mapSheetCropList[3].isOn] as [String : Any]
            ]
            return parameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        request.method = method
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let encodingData = try JSONEncoding.default.encode(request, with: parameters).httpBody
            request.httpBody = encodingData
            // Content-Type 헤더를 설정합니다.
        }catch(let error){
            print("변환이 안된다!!")
            print(error)
        }
        return request
    }
    
    
}
