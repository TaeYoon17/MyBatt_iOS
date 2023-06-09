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
    @Published var reply: ReplyModel? = nil
    var subscription = Set<AnyCancellable>()
    init(id: Int){
        print("ExpertMsgVM \(id)")
        self.getReply(id: id)
    }
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
    }
    func getReply(id:Int){
        ApiClient.shared.session.request(ExpertRouter.Reply(id: id),
                                                 interceptor: AuthAuthenticator.getAuthInterceptor)
                    .publishDecodable(type: ResponseWrapper<ReplyModel>.self)
                    .value()
                    .sink(receiveCompletion: { completion in
                        switch completion{
                        case .finished:
                            print("가져오기 성공")
                        case .failure(let error):
                            print("가져오기 실패")
                            print(error.localizedDescription)
                        }
                    }, receiveValue: {[weak self] output in
                        guard let response = output.data else {return}
                        self?.reply = response
                    }).store(in: &subscription)
    }
}
struct ReplyModel:Codable{
    let id, inquiryID, userID: Int?
    let contents, regDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case inquiryID = "inquiryId"
        case userID = "userId"
        case contents, regDate
    }
}
//{
//        "id": 10,
//        "inquiryId": 13,
//        "userId": 24,
//        "contents": "답변드립니다",
//        "regDate": "2023-06-09T14:17:19.194965"
//    }
