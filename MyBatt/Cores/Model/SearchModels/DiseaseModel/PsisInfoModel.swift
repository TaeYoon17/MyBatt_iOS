//
//  PsisInfoModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
struct PsisInfoResponseWrapper: Codable{
    let response: PsisInfoResponse
    enum CodingKeys: String, CodingKey{
        case response
    }
    
}
struct PsisInfoResponse: Codable{
    let totalCount: Int
    let buildTime: String
    let list: PsisInfoList?
    let displayCount, startPoint: Int
    enum CodingKeys: String, CodingKey {
        case totalCount
        case buildTime
        case list
        case displayCount, startPoint
    }
}
struct PsisInfoList:Codable{
    let item: [PsisInfo]
    enum CodingKeys: String, CodingKey{
        case item
    }
}

struct PsisInfo:Codable,Identifiable{
    var id = UUID()
    let pestiCode, diseaseUseSeq: Int
    let cropName,diseaseWeedName, useName, pestiKorName, pestiBrandName, compName: String
    let engName,cmpaItmNm,indictSymbl, applyFirstRegDate, cropCD, cropLrclCD, cropLrclNm, pestiUse: String
    let dilutUnit, useSuittime, useNum, wafindex: String

    enum CodingKeys: String, CodingKey {
        case pestiCode, diseaseUseSeq, cropName, diseaseWeedName, useName, pestiKorName, pestiBrandName, compName, engName, cmpaItmNm, indictSymbl, applyFirstRegDate
        case cropCD = "cropCd"
        case cropLrclCD = "cropLrclCd"
        case cropLrclNm, pestiUse, dilutUnit, useSuittime, useNum, wafindex
    }
}
