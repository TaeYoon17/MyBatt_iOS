//
//  ExpertModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
struct ExpertSendModel: Codable,Identifiable {
    let id: Int
    let userID, diagnosisRecordID: Int?
    let title, contents, regDate: String?
    let replyId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case diagnosisRecordID = "diagnosisRecordId"
        case title, contents, regDate
        case replyId
    }
}

