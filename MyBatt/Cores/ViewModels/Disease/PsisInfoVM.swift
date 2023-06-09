//
//  PsisInfoVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
import Combine
import Alamofire
final class PsisInfoVM: ObservableObject{
    var subscription = Set<AnyCancellable>()
    @Published var psisList: [PsisInfo] = []
    @Published var nowCnt: Int = -1
    @Published var maxCnt: Int = 0
    @Published var displayCnt: Int = 0
    let cropName: String
    let sickNameKor: String
    
    init(cropName:String?,sickNameKor:String?){
        self.cropName = cropName ?? ""
        self.sickNameKor = sickNameKor ?? ""
        requestSickList()
    }
    deinit {
        subscription.forEach { ele in
            ele.cancel()
        }
    }
    func requestSickList(){
        guard nowCnt * displayCnt <= maxCnt else {
            print("너무 많다!!")
            return }
//        print(self.cropName,self.sickNameKor,nowCnt)
        ApiClient.shared.session.request(CropInfoRouter.PsisList(cropName: self.cropName,
                                                                 diseaseWeedName: self.sickNameKor, displayCount: 20, startPoint: nowCnt + 1),interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<PsisInfoResponseWrapper>.self)
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
                guard let response: PsisInfoResponse = output.data?.response else { return }
                guard self!.nowCnt < response.startPoint else {return}
                if let totalCnt = response.totalCount,self?.maxCnt != totalCnt{
                    self?.maxCnt = totalCnt
                }
                self?.nowCnt = response.startPoint
                self?.psisList.append(contentsOf: response.list!.item ?? [])
            }).store(in: &subscription)
    }
}
