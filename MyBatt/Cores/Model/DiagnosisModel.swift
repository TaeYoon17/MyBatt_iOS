//
//  DiagnosisModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import Foundation

enum DiagnosisType:Int{
    case none = -1
    case PepperNormal = 0
    case PepperMildMotle
    case PepperSpot
    case StrawberryNormal
    case StrawberryGrayMold
    case StrawberryPowderyMildew
    case LettuceNormal
    case LettuceMycosis
    case LettuceDownyMildew
    case TomatoNormal
    case TomatoLeafFungus
    case TomatoYellowLeafRoll
    
}

// MARK: -- RegData를 String으로 했음!!
struct DiagnosisResponse:Codable{
    let cropType: Int?
    let id, diagnosisRecordID, userID: Int?
    let userLongitude, userLatitude: Double?
    let regDate, imagePath: String?
    let diagosisResults: [DiagnosisItem]?

    enum CodingKeys: String, CodingKey {
        case cropType, id
        case diagnosisRecordID = "diagnosisRecordId"
        case userID = "userId"
        case userLongitude, userLatitude, regDate, imagePath, diagosisResults
    }
}
struct DiagnosisItem: Codable{
    let diseaseCode: Int
    let accuracy: Double
    let boxX1:Double
    let boxX2: Double
    let boxY1:Double
    let boxY2:Double
}
struct Diagnosis{
    static let koreanTable:[DiagnosisType:String] = [
        .PepperNormal:"정상",.TomatoNormal:"정상",.LettuceNormal:"정상",.StrawberryNormal:"정상",
        .PepperMildMotle:"고추 마일드 모틀 바이러스",.PepperSpot:"고추 점무늬병",
        .StrawberryGrayMold:"딸기 잿빛곰팡이병",.StrawberryPowderyMildew:"딸기 흰가루병",
        .LettuceMycosis:"상추 균핵병",.LettuceDownyMildew:"상추 노균병",
        .TomatoLeafFungus:"토마토 잎곰팡이병",.TomatoYellowLeafRoll:"토마토 황화잎말이바이러스",
        .none : "진단 실패"
    ]
}
