//
//  DiagnosisModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import Foundation



// MARK: -- RegData를 String으로 했음!!
struct DiagnosisResponse:Codable{
    let cropType: Int?
    let id, diagnosisRecordID, userID: Int?
    let userLongitude, userLatitude: Double?
    var regDate:String?
    let imagePath: String?
    let diagnosisResults: [DiagnosisItem]?

    enum CodingKeys: String, CodingKey {
        case cropType, id
        case diagnosisRecordID = "diagnosisRecordId"
        case userID = "userId"
        case userLongitude, userLatitude, regDate, imagePath, diagnosisResults
    }
}
struct DiagnosisItem: Codable,Identifiable{
    var id = UUID()
    let diseaseCode: Int?
    let accuracy: Double?
    let sickKey: String?
    let boxX1:Double
    let boxX2: Double
    let boxY1:Double
    let boxY2:Double
    enum CodingKeys: String, CodingKey {
        case diseaseCode
        case accuracy
        case sickKey
        case boxX1
        case boxX2
        case boxY1
        case boxY2
    }
}

