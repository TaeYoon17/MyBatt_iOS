//
//  ExpertSheetVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
import Alamofire
import Combine
import CoreLocation
final class ExpertSheetVM:NSObject,ObservableObject{
    @Published var isSendCompleted: Bool = false
    @Published var location: String? = nil
    var subscription = Set<AnyCancellable>()
    override init(){
        print("전문가 진단 찾기 시트")
        super.init()
    }
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
        print("ExpertSheetVM 사라짐")
    }
    func getLocation(latitude: Double,longtitude: Double){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude,longitude: longtitude)) {[weak self] marks, error in
            if let pm: CLPlacemark = marks?.first{
                let address: String = "\(pm.locality ?? "") \(pm.name ?? "")"
                self?.location = address
            }else{
                self?.location = "찾는 위치가 없습니다."
                print("찾는 위치가 없습니다.")
            }
        }
        print("getLocation(\(latitude): Double,\(longtitude): Double)")
    }
    func requestToExpert(diagnosisId:Int,title:String,contents:String){
        ApiClient.shared.session.request(ExpertRouter.Register(id: diagnosisId, title: title, contents: contents),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<ExpertSendModel>.self)
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
                self?.isSendCompleted = true
                print("문의 성공")
            }).store(in: &subscription)
    }
}
