//
//  ExpertMainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
import Combine
import Alamofire
final class ExpertMainVM:ObservableObject{
    @Published var unResponseItem:[ExpertSendModel] = []
    @Published var responsedItem:[ExpertSendModel] = []
    @Published var unResponseDiagnosis:[DiagnosisResponse?] = []
    @Published var responsedDiagnosis:[DiagnosisResponse?] = []
    var subscription = Set<AnyCancellable>()
    init(){
        self.getList()
    }
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
    }
    private func getList(){
        ApiClient.shared.session.request(ExpertRouter.List,
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
        .publishDecodable(type: ResponseWrapper<[ExpertSendModel]>.self)
        .value()
        .sink(receiveCompletion: { completion in
            switch completion{
            case .finished:
                print("getList 가져오기 성공")
            case .failure(let error):
                print("가져오기 실패")
                print(error.localizedDescription)
            }
        }, receiveValue: {[weak self] output in
            guard let response: [ExpertSendModel] = output.data else {
                print("ExpertRouter.List 반환 실패")
                return
            }
            //                self?.listItem = response
            self?.responsedItem = []
            self?.unResponseItem = response.filter({ model in
                if let id = model.replyId, id != -1{
                    self?.responsedItem.append(model)
                    return false
                }
                return true
            })
            print("Response 반환 시작")
            self?.getDiagnosisResponses(target: 0)
            self?.getDiagnosisResponses(target: 1)
        }).store(in: &subscription)
    }
    private func getDiagnosisResponses(target: Int = 0){
        let item = target == 0 ? responsedItem : unResponseItem
        if target == 0{
            self.responsedDiagnosis = Array(repeating: nil, count: responsedItem.count)
        }else{
            self.unResponseDiagnosis = Array(repeating: nil, count: unResponseItem.count)
        }
        item.enumerated().publisher.sink { completion in
            switch completion{
            case .finished:
                    print("getDiagnosisResponses(\(target) 성공")
            case .failure(_): break
            }
        }receiveValue:{[weak self] (idx,model) in
            guard let id = model.diagnosisRecordID else {
                return
            }
            ApiClient.shared.session.request(DiagnosisRouter.Record(id: id),
                                             interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<DiagnosisResponse>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: { output in
                guard let response: DiagnosisResponse = output.data else {
                    return
                }
                if target == 0{
                    self?.responsedDiagnosis[idx] = response
                }else{
                    self?.unResponseDiagnosis[idx] = response
                }
            }).store(in: &self!.subscription)
        }.store(in: &subscription)
    }
}
