//
//  DiseaseInfoVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
import Alamofire
import Combine
final class DiseaseInfoVM: ObservableObject{
    @Published var diseaseInfoModel: DiseaseInfoModel? = nil
    var errorMessage = PassthroughSubject<String,Never>()
    var subscription = Set<AnyCancellable>()
    init(sickKey: String){
        requestDiseaseInfo(sickKey: sickKey)
    }
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
    }
    private func requestDiseaseInfo(sickKey: String){
        ApiClient.shared.session.request(CropInfoRouter.SickDetail(sickKey: sickKey),interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<DiseaseInfoModel>.self)
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
                guard var response: DiseaseInfoModel = output.data else {
                    print("에러 메시지 전송 \(output.message)")
                    self?.errorMessage.send(output.message ?? "")
                    return
                }
                self?.brChange(str: &response.developmentCondition)
                self?.brChange(str: &response.symptoms)
                self?.brChange(str: &response.preventionMethod)
//                self?.brChange(&response.preventionMethod)
                
                self?.diseaseInfoModel = response
            }).store(in: &subscription)
    }
    private func brChange( str: inout String){
        str = str.replacingOccurrences(of: "<br/>", with: "\n")
    }
}
