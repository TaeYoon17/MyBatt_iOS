//
//  MapModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import Foundation
enum DurationType:String, CaseIterable{
    case day = "하루 전"
    case week = "일주일 전"
    case fortnight = "보름 전"
    case month = "한달 전"
    case quarter = "3달 전"
    case custom = "자체 설정"
}
