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
struct CM_GroupItem:Identifiable{
    let id:Int
    let imgPath:String
    var address:String
    let regDate:String
    let cropType: CropType
    let diseaseType: DiagnosisType
    let accuracy:Double
}
final class CM_GroupVM:NSObject,ObservableObject{
//    @Published var cm_recordWrapper:[CM_RecordWrapper] = []
    @Published var cm_groupItems:[CM_GroupItem] = []
    @Published var cm_diagnosisItem:DiagnosisResponse?
    var diagnosisResponseCompleted = PassthroughSubject<Void,Never>()
    var geoCoders:[(MTMapReverseGeoCoder?,Int)] = []
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
                    let geoCoder = MTMapReverseGeoCoder(mapPoint: .init(geoCoord: .init(latitude: item.userLatitude, longitude: item.userLongitude)), with: self, withOpenAPIKey: self?.locationApiKey)
                    if let geoCoder = geoCoder{
                        self?.geoCoders.append((geoCoder,idx))
                    }else{
                        self?.geoCoders.append((nil,idx))
                    }
                    let regDate:String = Date.changeDateFormat(dateString: item.regDate)
                    return CM_GroupItem(id:item.id,
                                        imgPath: item.imagePath,
                                        address: "주소를 찾을 수 없습니다.",
                                        regDate:regDate,
                                        cropType: CropType(rawValue: item.cropType) ?? .none,
                                        diseaseType: DiagnosisType(rawValue: wrapper.diagnosisResultList?[0].diseaseCode ?? -1) ?? .none,
                                        accuracy:wrapper.diagnosisResultList?[0].accuracy ?? 0)
                }
                self?.geoCoders.forEach({ (coder,idx) in
                    if let coder = coder{
                        coder.startFindingAddress()
                    }
                })
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
                self?.cm_diagnosisItem = response
                self?.diagnosisResponseCompleted.send()
            }).store(in: &subscription)
    }
}


//MARK: -- 지도 위치 변환기
extension CM_GroupVM:MTMapReverseGeoCoderDelegate{
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        let geoCoder = geoCoders.first { item in
            item.0 == rGeoCoder
        }
        if let geoCoder = geoCoder, self.cm_groupItems.count > geoCoder.1{
            self.cm_groupItems[geoCoder.1].address = addressString
        }else{
            print("geoCoder")
        }
    }
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, failedToFindAddressWithError error: Error!) {
        let geoCoder = geoCoders.first { item in
            item.0 == rGeoCoder
        }
        if let geoCoder = geoCoder, cm_groupItems.count > geoCoder.1{
            self.cm_groupItems[geoCoder.1].address = "주소를 찾을 수 없습니다."
        }
    }
}
