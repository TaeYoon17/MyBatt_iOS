//
//  DiagnosisModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import Foundation
struct Diagnosis:Codable{
    let responseCode: Int
    let cropType: Int
    let regData: String
    let diagnosisItems:[DiagnosisItem]
    let imagePath: String
}
struct DiagnosisItem: Codable{
    let diseaseCode: String
    let accuracy: Double
    let boxX1:Double
    let boxX2: Double
    let boxY1:Double
    let boxY2:Double
}
