//
//  TokenResponse.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import Foundation

struct TokenResponse: Codable {
    let message: String
    let token: TokenData
}
