//
//  ExpertMsgVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
import Alamofire
import Combine
final class ExpertMsgVM:ObservableObject{
//    @Published
    var subscription = Set<AnyCancellable>()
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
    }
    func requestToExpert(id:Int,title:String,contents:String){
//        ApiClient.shared.session.request(ExpertRouter.Register(id: id, title: title, contents: contents),
//                                         interceptor: AuthAuthenticator.getAuthInterceptor)
//            .publishDecodable(type: ResponseWrapper<ExpertSendModel>.self)
//            .value()
//            .sink(receiveCompletion: { completion in
//                switch completion{
//                case .finished:
//                    print("가져오기 성공")
//                case .failure(let error):
//                    print("가져오기 실패")
//                    print(error.localizedDescription)
//                }
//            }, receiveValue: {[weak self] output in
//                self?.isSendCompleted = true
//                print("문의 성공")
//            }).store(in: &subscription)
    }
}
