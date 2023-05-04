//
//  Friend.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/21.
//

import Foundation

struct Friend: Identifiable{
    var id = UUID().uuidString
    var name: String
    var detail: String
}

var friends = Array(repeating: Friend(name: "kaviya", detail: "3 miles Away"), count: 30)
