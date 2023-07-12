//
//  CM_GroupVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/08.
//

import SwiftUI
import Alamofire
import Combine
import CoreLocation
struct CM_GroupItem:Identifiable,Equatable{
    static func == (lhs: CM_GroupItem, rhs: CM_GroupItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let id:Int
    let imgPath:String
    var address:String
    let regDate:String
    let cropType: DiagCropType
    let diseaseType: DiagDiseaseType
    let accuracy:Double
    var geo: Geo
}
final class CM_GroupVM:NSObject,ObservableObject{
//    @Published var cm_recordWrapper:[CM_RecordWrapper] = []
    @Published var cm_groupItems:[CM_GroupItem] = []
    @Published var cm_diagnosisItem:DiagnosisResponse?
    var diagnosisResponseCompleted = PassthroughSubject<Void,Never>()
    var changeGroupCompleted = PassthroughSubject<Void,Never>()
    var geoCoders:[(String?,Int)] = []
    var subscription = Set<AnyCancellable>()
    let id: Int
    let locationApiKey: String?
    init(id: Int) {
        self.id = id
        self.locationApiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String
        super.init()
        self.getList()
    }
    func getList(){
        ApiClient.shared.session.request(CM_Router.CM_GroupRecord(id: self.id),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<[CM_RecordWrapper]>.self)
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
                guard let response: [CM_RecordWrapper] = output.data else { return }
                self?.geoCoders = []
                self?.cm_groupItems = response.enumerated().map { (idx,wrapper) in
                    let item = wrapper.diagnosisRecord
                    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: item.userLatitude,longitude: item.userLongitude)) { marks, error in
                        if let pm: CLPlacemark = marks?.first{
                            //                        \(pm.name ?? "위치 정보 없음")
                            let address: String = "\(pm.locality ?? "") \(pm.name ?? "")"
                            print(address)
                            self?.geoCoders.append((address,idx))
                        }else{
                            self?.geoCoders.append((nil,idx))
                            print("찾는 위치가 없습니다.")
                        }
                    }
                    let regDate:String = Date.changeDateFormat(dateString: item.regDate)
                    return CM_GroupItem(id:item.id,
                                        imgPath: item.imagePath,
                                        address: "주소를 찾을 수 없습니다.",
                                        regDate:regDate,
                                        cropType: DiagCropType(rawValue: item.cropType) ?? .none,
                                        diseaseType: DiagDiseaseType(rawValue: wrapper.diagnosisResultList?[0].diseaseCode ?? -1) ?? .none,
                                        accuracy:wrapper.diagnosisResultList?[0].accuracy ?? 0, geo: (item.userLatitude,item.userLongitude))
                }
            }).store(in: &subscription)
    }
    func getDiagnosisItem(id: Int){
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
            }, receiveValue: {[weak self] output in
                guard let response = output.data else {return}
                //가져오고 가져온 것을 완료함을 알림
                self?.cm_diagnosisItem = response
                self?.diagnosisResponseCompleted.send()
            }).store(in: &subscription)
    }
    func changeItemGroup(toGroupId: Int, itemId: Int){
        ApiClient.shared.session.request(CM_Router.CM_GroupItemChange(groupId: toGroupId, itemId: itemId),
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
            }, receiveValue: {[weak self] output in
                self?.changeGroupCompleted.send()
                self?.getList()
            }).store(in: &subscription)
    }
}
