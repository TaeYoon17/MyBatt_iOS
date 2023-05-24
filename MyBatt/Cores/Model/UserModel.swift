//
//  UserModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/23.
//

import Foundation
typealias Geo = (latitude: Double,longtitude: Double)
struct UserModel{
    var token: TokenData? = UserDefaultsManager.shared.getTokens()
    var userKey: String?
    var location: Geo = (0,0)
}

struct UserCropManage{}
