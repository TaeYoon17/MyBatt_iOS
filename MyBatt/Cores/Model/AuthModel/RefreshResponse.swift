//
//  RefreshResponse.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/25.
//

import Foundation
struct RefreshResponse:Codable{
    let message:String
    let accessToken:String
    let status: String
}
