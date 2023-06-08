//
//  CM_RecordModels.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
struct CM_RecordWrapper: Codable{
    let diagnosisRecord: CM_RecordItem
    let diagnosisResultList: [CM_DiagnosisResultItem]?
    enum CodingKeys: String, CodingKey {
        case diagnosisRecord
        case diagnosisResultList
    }
}

struct CM_RecordItem: Codable,Identifiable{
    let id, userID: Int
    let userLatitude, userLongitude: Double
    let regDate: String
    let cropType: Int
    let imagePath: String
    let categoryID: Int
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case userLatitude, userLongitude, regDate, cropType, imagePath
        case categoryID = "categoryId"
    }
}

struct CM_DiagnosisResultItem: Codable{
    let id, responseCode: Int
    let diagnosisRecord: CM_RecordItem
    let diseaseCode: Int
    let sickKey: String?
    let accuracy, boxX1, boxX2, boxY1: Double
    let boxY2: Double
    enum CodingKeys: String, CodingKey {
        case id, responseCode
        case diagnosisRecord
        case diseaseCode
        case sickKey
        case accuracy, boxX1, boxX2, boxY1
        case boxY2
    }
}
