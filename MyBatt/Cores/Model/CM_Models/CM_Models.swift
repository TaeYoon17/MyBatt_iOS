//
//  CM_Models.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation

struct CM_GroupListItem:Codable,Identifiable{
    var id: Int
    let userID: Int?
    let name: String
    let cnt: Int
    let memo: String
    let regDt: String
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        case name
        case cnt
        case memo
        case regDt
    }
}
