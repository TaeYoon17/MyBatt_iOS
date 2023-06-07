//
//  OutBreakViewMoel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
import Alamofire
final class OutBreakViewMoel: ObservableObject{
    var subscription = Set<AnyCancellable>()
    @Published var outbreakModel: OutbreakModel?
    init(){
    }
    deinit{
        subscription.forEach{
            $0.cancel()
        }
    }
}
