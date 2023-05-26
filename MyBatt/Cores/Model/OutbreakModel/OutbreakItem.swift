//
//  OutbreakItem.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/26.
//

import Foundation
struct OutbreakItem: Codable,Identifiable{
    var id = UUID()
    let cropName: String
    let sickNameKor:String
    let sickKey: String?
    enum CodingKeys:String, CodingKey {
        case cropName
        case sickKey
        case sickNameKor
    }
}
