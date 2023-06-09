//
//  SearchMainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/26.
//

import Foundation
import Alamofire
import Combine
final class SeaerchMainVM: ObservableObject{
    @Published var searchResults: [SickItem] = []
    @Published var searchCnt = 0
    @Published var sickListResponse:SickListResponse?
    @Published var prevCropName = ""
    @Published var prevSickName = ""
    @Published var nowCnt: Int = -1
    var nowIdx = 0
    var subscription = Set<AnyCancellable>()
    deinit{
        subscription.forEach { ele in
            ele.cancel()
        }
    }
    func requestSickList(cropName:String?,sickNameKor:String?){
        if !(prevCropName == cropName && prevSickName == sickNameKor){
            self.nowCnt = -1
            self.searchCnt = 0
            searchResults = []
            prevCropName = cropName ?? ""
            prevSickName = sickNameKor ?? ""
        }
        ApiClient.shared.session.request(CropInfoRouter.SickList(cropName: cropName ?? "", sickNameKor: sickNameKor ?? "", displayCount: 20, startPoint: nowIdx + 1),interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<SickListResponse>.self)
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
                guard let response: SickListResponse = output.data else { return }
                guard (self!.nowCnt * 20) <= response.totalCnt else {return}
                if self?.searchCnt != response.totalCnt{
                    self?.searchCnt = response.totalCnt
                }
                self?.nowCnt += 1
                self?.searchResults.append(contentsOf: response.sickList)
            }).store(in: &subscription)
    }
}
