//
//  MemoVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import Foundation
import Combine
final class MemoVM: ObservableObject{
    let diagnosisID: Int
    @Published var memoList:[MemoModel] = []
    var subscription = Set<AnyCancellable>()
    init(diagnosisID: Int){
        self.diagnosisID = diagnosisID
        requestMemoList()
    }
    deinit{
        subscription.forEach{ $0.cancel()}
    }
    func requestMemoList(){
        if diagnosisID == -1 {
            print("responseError")
            return
        }
        ApiClient.shared.session.request(MemoRouter.List(diagnosisRecordID: self.diagnosisID),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<[MemoModel]>.self)
            .value().sink { completion in
                switch completion{
                case .finished: print("성공적 종료")
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { data in
                if let datas = data.data{
                    self.memoList = datas
                }
            }.store(in: &subscription)
    }
    func addMemo(contents: String){
        if diagnosisID == -1 {
            print("responseError")
            return
        }
        ApiClient.shared.session.request(MemoRouter.Add(diagnosisRecordID: self.diagnosisID, contents: contents),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
        .publishDecodable(type: ResponseWrapper<MemoModel>.self)
        .value().sink { completion in
            switch completion{
            case .finished: print("성공적 종료")
            case .failure(let err):
                print(err)
            }
        } receiveValue: { data in
            print(data)
        }.store(in: &subscription)
    }
    func editMemo(memoId: Int){}
    func deleteMemo(memoId: Int){
//        ApiClient.shared.session.request(MemoRouter.Delete(memoID: memoId),interceptor: AuthAuthenticator.getAuthInterceptor)
//        .publishDecodable(type: ResponseWrapper<MemoModel>.self)
//        .value().sink { completion in
//            switch completion{
//            case .finished: print("성공적 종료")
//            case .failure(let err):
//                print(err)
//            }
//        } receiveValue: { data in
//            print(data)
//        }.store(in: &subscription)
    }
    
}
