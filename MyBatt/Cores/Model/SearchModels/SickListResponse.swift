//
//  SickListResponse.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/31.
//

import Foundation
struct SickListResponse: Codable {
    let totalCnt: Int
    let sickList: [SickItem]
    enum CodingKeys : String, CodingKey{
        case totalCnt
        case sickList
      }
}
struct SickItem:Codable,Identifiable,Equatable{
    var id = UUID()
    let sickKey: String
    let cropName: String
    let sickNameKor, sickNameEng: String
    let thumbImg: String?
    enum CodingKeys : String, CodingKey{
        case sickKey
        case cropName
        case sickNameKor,sickNameEng
        case thumbImg
      }
}
