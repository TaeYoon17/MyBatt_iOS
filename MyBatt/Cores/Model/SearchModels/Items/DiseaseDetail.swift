//
//  DiseaseDetail.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/28.
//

import Foundation
struct DiseaseDetail: Codable {
    let developmentCondition, symptoms, preventionMethod, infectionRoute: String
    let imageList: [DiseaseDetailImage]
}

// MARK: - ImageList
struct DiseaseDetailImage: Codable {
    let imageTitle: String
    let imagePath: String
}
