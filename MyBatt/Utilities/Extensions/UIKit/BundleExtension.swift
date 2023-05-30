//
//  BundleExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/30.
//

import Foundation
extension Bundle{
    static public var getKakaoRestApi:String{
        if let infoDict = Bundle.main.infoDictionary {
            if let kakao_rest_api_key = infoDict["KAKAO_REST_API_KEY"] as? String {
                return kakao_rest_api_key
            }
        }
        return ""
    }
}
