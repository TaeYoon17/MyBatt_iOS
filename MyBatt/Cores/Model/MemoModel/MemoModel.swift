//
//  MemoModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import Foundation
struct MemoModel: Codable,Identifiable {
    var id = UUID()
    let memoId: Int
    let diagnosisRecord: DiagnosisRecord?
    let regDt, updateDt, contents: String
    enum CodingKeys: String, CodingKey {
        case memoId = "id"
        case diagnosisRecord
        case regDt, updateDt, contents
    }
}
