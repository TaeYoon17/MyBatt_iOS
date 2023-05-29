//
//  Pesticide.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/28.
//

import Foundation
struct Pesticide: Codable {
    let pestiCode, diseaseUseSeq: Int
    let cropName, diseaseWeedName, useName, pestiKorName: String
    let pestiBrandName, compName, engName, cmpaItmNm: String
    let indictSymbl, applyFirstRegDate, cropCD, cropLrclCD: String
    let cropLrclNm, pestiUse, dilutUnit, useSuittime: String
    let useNum, wafindex: String
    enum CodingKeys: String, CodingKey {
        case pestiCode, diseaseUseSeq, cropName, diseaseWeedName, useName, pestiKorName, pestiBrandName, compName, engName, cmpaItmNm, indictSymbl, applyFirstRegDate
        case cropCD = "cropCd"
        case cropLrclCD = "cropLrclCd"
        case cropLrclNm, pestiUse, dilutUnit, useSuittime, useNum, wafindex
    }
}
