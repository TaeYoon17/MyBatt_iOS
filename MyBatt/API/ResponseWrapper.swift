//
//  ResponseWrapper.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/24.
//

import Foundation
let errorCode = "NOTHING_DETECTED"
struct ResponseWrapper<T:Codable>:Codable{
    let data: T?
    let message:String?
    let code : String?
    enum CodingKeys:String, CodingKey {
        case data
        case message
        case code
    }
}
