//
//  LocationService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/12.
//

import Foundation
import CoreLocation
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate{
    private lazy var locationManager = CLLocationManager()
    lazy var geocoder: MTMapReverseGeoCoder? = nil
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var address: String? = nil
    override init() {
        super.init()
        print("LocationService Init!!")
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.delegate = self
        switch locationManager.authorizationStatus{
        case .denied: break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    deinit{
        print("사라진 거임!")
    }
    func updateCurrent(){
        coordinate = nil
        isLoading = true
        print("request start!!")
        locationManager.requestLocation()
        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            self.isLoading = false
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 사용자가 장치에서 위치 서비스를 활성화하지 않았을때나,
        // 건물 내부에 있어 GPS 신호가 잡히지 않을 경우.
        // 예를 들자면 사용자에게 GPS 신호가 있는 장소로 걸어가라고 요청하는 경고를 표시하는 것이 좋습니다.
        coordinate = nil
        isLoading = false
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations라는 배열로 현재 위치를 가져온다.
        // 첫번째 인덱스에 있는 정보로 활용이 가능하다.
        defer{
            isLoading = false
        }
        if let location = locations.first {
            self.coordinate = location.coordinate
            let mtGeo = MTMapPoint(geoCoord: .init(latitude: Double(location.coordinate.latitude)
                                                   ,longitude: Double(location.coordinate.longitude)))
            guard let apiKey:String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else{
                print("가져오기 실패")
                isLoading = false
                return
            }
            guard let geoCoder: MTMapReverseGeoCoder = MTMapReverseGeoCoder(mapPoint: mtGeo, with: self, withOpenAPIKey: apiKey) else {
                print("에러 발생")
                return
            }
            self.geocoder = geoCoder
            self.geocoder?.startFindingAddress()
        }
        isLoading = false
    }
}
extension LocationService:MTMapReverseGeoCoderDelegate{
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
        guard let addressString = addressString else { return }
        print(addressString)
        address = addressString
//        geocoder = nil
    }
    func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, failedToFindAddressWithError error: Error!) {
        print("에러였던거임!")
    }
}
