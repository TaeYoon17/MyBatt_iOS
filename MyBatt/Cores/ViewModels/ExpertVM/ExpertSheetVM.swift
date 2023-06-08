//
//  ExpertSheetVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import Foundation
import Alamofire
import Combine
final class ExpertSheetVM:NSObject,ObservableObject{
    @Published var isSendCompleted: Bool = false
    @Published var location: String? = nil
    var subscription = Set<AnyCancellable>()
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String
    var geoCoder : MTMapReverseGeoCoder? = nil
    override init(){
        super.init()
    }
    deinit{
        subscription.forEach { sub in
            sub.cancel()
        }
    }
    func getLocation(latitude: Double,longtitude: Double){
        print("getLocation(\(latitude): Double,\(longtitude): Double)")
        self.geoCoder = MTMapReverseGeoCoder(mapPoint: .init(geoCoord: .init(latitude: latitude, longitude: longtitude)), with: self, withOpenAPIKey: self.apiKey)
        guard let geoCoder = geoCoder else {
            print("변환을 실패한거임!!")
            return
        }
        print("startAddressing 시작합니다아~~")
        DispatchQueue.main.async {
            geoCoder.startFindingAddress()
        }
    }
    func requestToExpert(id:Int,title:String,contents:String){
        ApiClient.shared.session.request(ExpertRouter.Register(id: id, title: title, contents: contents),
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
extension ExpertSheetVM:MTMapReverseGeoCoderDelegate{
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        print("위치 가져오기 성공")
        self.location = addressString
    }
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, failedToFindAddressWithError error: Error!) {
        print("위치 가져오기 실패")
        self.location = "주소를 찾을 수 없습니다"
    }
}
