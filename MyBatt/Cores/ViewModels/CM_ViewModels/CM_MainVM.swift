//
//  CM_MainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
import Combine
import Alamofire
final class CM_MainVM: ObservableObject{
    @Published var cm_GroupList: [CM_GroupListItem] = []
    @Published var unclassfiedGroup: CM_GroupListItem? = nil
    var subscription = Set<AnyCancellable>()
    init(){
        self.getList()
    }
    private func getList(){
        ApiClient.shared.session.request(CM_Router.CM_List,interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<[CM_GroupListItem]>.self)
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
                guard let response: [CM_GroupListItem] = output.data else { return }
                self?.cm_GroupList = response.filter { item in
                    if item.name == "unclassified"{
                        self?.unclassfiedGroup = item
                        return false
                    }
                    return true
                }
            }).store(in: &subscription)
    }
}
