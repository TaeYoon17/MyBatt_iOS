//
//  OutbreakModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/26.
//

import Foundation
struct OutbreakModel:Codable{
    let warningListSize: Int
    let warningList: [OutbreakItem]
    let watchListSize: Int
    let watchList: [OutbreakItem]
    let forecastListSize: Int
    let forecastList:[OutbreakItem]
    enum CodingKeys:String, CodingKey {
        case warningListSize
        case warningList
        case watchListSize
        case watchList
        case forecastListSize
        case forecastList
    }
}
