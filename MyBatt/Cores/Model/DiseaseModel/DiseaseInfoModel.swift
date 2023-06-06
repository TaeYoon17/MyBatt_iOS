//
//  DiseaseInfoModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
struct DiseaseInfoModel: Codable{
    var developmentCondition, symptoms, preventionMethod, infectionRoute: String
    let imageList: [DiseaseInfoImage]
    enum CodingKeys : String, CodingKey{
        case developmentCondition, symptoms, preventionMethod, infectionRoute
        case imageList
      }
}
struct DiseaseInfoImage: Codable,Identifiable {
    var id = UUID()
    let imageTitle: String
    let imagePath: String
    enum CodingKeys : String, CodingKey{
        case imageTitle
        case imagePath
      }
}
