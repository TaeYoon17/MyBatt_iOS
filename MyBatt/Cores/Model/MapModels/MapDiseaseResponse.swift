//
//  NearDiseasesResponse.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import Foundation
struct MapDiseaseResponse: Codable,Identifiable {
    let id, responseCode: Int
    let diagnosisRecord: DiagnosisRecord
    let diseaseCode: Int?
    let sickKey: String?
    let accuracy, boxX1, boxX2, boxY1: Double
    let boxY2: Double
}

// MARK: - DiagnosisRecord
struct DiagnosisRecord: Codable,Identifiable {
    let id, userID: Int
    let userLatitude, userLongitude: Double
    let regDate: String
    let cropType: Int
    let imagePath: String
    let categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case userLatitude, userLongitude, regDate, cropType, imagePath
        case categoryID = "categoryId"
    }
}

struct MapDiseaseResult:Identifiable,Equatable{
    static func == (lhs: MapDiseaseResult, rhs: MapDiseaseResult) -> Bool {
        lhs.id == rhs.id && lhs.results == rhs.results
    }
    let id = UUID()
    var results: [DiagCropType:[MapItem]]
}
