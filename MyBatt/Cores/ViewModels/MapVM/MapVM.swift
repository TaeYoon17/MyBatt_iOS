//
//  MapVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import Foundation
import MapKit
import Combine
protocol Markerable:Identifiable{
    var geo: Geo { get set }
}
final class MapVM<T:Markerable>:NSObject, ObservableObject{
    private let service = LocationService.shared
    var items: [T] = []
    @Published var tappedItem: T? = nil
    @Published var isGPSOn = false
    @Published var center: Geo = (37.596464,127.085972)
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: .init(latitude: 37.596464, longitude: 127.085972), span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001))
    @Published var locationName: String = ""
    var subscription = Set<AnyCancellable>()
    var isTapped = false
    override init(){
        super.init()
        addSubscriber()
    }
    private func addSubscriber(){
        requestSubscribers()
        responseSubscribers()
    }
    deinit{
        self.subscription.forEach { can in
            can.cancel()
        }
    }
    func centerOnMarker(_ locationCoordinate: T){
        let loc = locationCoordinate.geo
        print(loc)
        self.region.center = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longtitude)
        self.isTapped = true
        self.tappedItem = locationCoordinate
    }
    func getNowLocation(){
        self.service.getCurrentLocation()
    }
    
}
//MARK: --  LocationService에게 요청하는 것들
fileprivate extension MapVM{
    private func requestSubscribers(){
        //     사용자가 drag해서 바뀌는 좌표에서 주소 얻기,
        //     center는 좌표의 주변 병해를 가져오는 것... => 버튼으로 재검색 기능 구현하기
//        self.$region.sink { [weak self] region in
//            guard let _self = self else {return }
//            DispatchQueue.main.async {
//                _self.center = (region.center.latitude,region.center.longitude)
//            }
//            _self.service.requestAddress(geo: (region.center.latitude,region.center.longitude))
//        }.store(in: &subscription)
        self.$region.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink {[weak self] output in
                guard let _self = self else { return }
                let geo = Geo(output.center.latitude,output.center.longitude)
                _self.service.requestAddress(geo: geo)
                if isDistanceGreaterThanOrEqualTo500m(lat1: _self.center.latitude, lon1: _self.center.longtitude, lat2: geo.latitude, lon2: geo.longtitude){
                    print("좌표 차이가 커 병해 진단!!")
                    _self.center = geo
                }else{
                    print("좌표 차이가 작아 병해 진단하지 않음!!")
                }
            }.store(in: &subscription)
        //      사용자가 gps버튼을 누를 때마다 위치 변환 기능을 실행하는 것
        self.$isGPSOn.sink {[weak self] val in
            guard let _self = self else {return}
            if val{
                _self.service.startUpdatingLocation()
            }else{
                _self.service.stopUpdatingLocation()
            }
        }.store(in: &subscription)
    }
}
//MARK: -- LocationService에서 받는 처리
fileprivate extension MapVM{
    private func responseSubscribers(){
        self.service.addressPasthrough.sink { [weak self] str in
            guard let _self = self else { return }
            if let str = str{
                _self.locationName = str
            }else{
                _self.locationName = "위치 정보가 없습니다!"
            }
        }.store(in: &subscription)
        self.service.locationPassthrough.sink{[weak self] loc in
            guard let _self = self else { return }
//            _self.center = loc
            _self.region.center = CLLocationCoordinate2D(geo: loc)
        }.store(in: &subscription)
    }
}

func isDistanceGreaterThanOrEqualTo500m(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Bool {
    let R = 6371.0 // 지구의 반지름 (단위: km)

    let lat1Rad = lat1 * .pi / 180.0
    let lon1Rad = lon1 * .pi / 180.0
    let lat2Rad = lat2 * .pi / 180.0
    let lon2Rad = lon2 * .pi / 180.0

    let dlat = lat2Rad - lat1Rad
    let dlon = lon2Rad - lon1Rad

    let a = sin(dlat/2) * sin(dlat/2) + cos(lat1Rad) * cos(lat2Rad) * sin(dlon/2) * sin(dlon/2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))

    let distance = R * c * 1000 // 거리 계산 (단위: m)

    return distance >= 500
}
