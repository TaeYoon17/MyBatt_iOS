//
//  UserData.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import Foundation

import Foundation

//"user": {
//        "id": 3,
//        "name": "tester01",
//        "email": "tester01@email.com",
//        "avatar": "https://www.gravatar.com/avatar/b87c0cd09c8c06be1d50f18d2104c814.jpg?s=200&d=robohash"
//    }

// 서버에서 넘어온 사용자 데이터
//struct UserData : Codable, Identifiable {
//    var uuid: UUID = UUID()
//    var id : Int
//    var name: String
//    var email: String
//    var avatar: String
//    private enum CodingKeys: String, CodingKey{
//        case id
//        case name
//        case email
//        case avatar
//    }
//}



struct RegisterResponse: Codable,Identifiable{
    var uuid: UUID = UUID()
    var id: String{
        self.data?.email ?? uuid.uuidString
    }
    var code: String?
    var message: String
    var data: RegisterData?
    private enum CodingKeys: String, CodingKey{
        case code
        case message
        case data
    }
}
struct RegisterData: Codable,Identifiable{
    var uuid: UUID = UUID()
    var id: String{
        self.email
    }
    var email: String
    var name: String
    var regDt: String
    var type: String
    private enum CodingKeys: String, CodingKey{
        case email
        case name
        case regDt
        case type
    }
}

struct LogInResponse: Codable,Identifiable{
    var uuid: UUID = UUID()
    var id:String{ self.key }
    var key:String
    var refreshToken: String
    var accessToken: String
    var grantType: String?
    private enum CodingKeys: String, CodingKey{
        case key
        case accessToken
        case refreshToken
        case grantType
    }
}


// 앱 전체에서 사용할 유저 데이터
struct UserData{
    let key: String
}
