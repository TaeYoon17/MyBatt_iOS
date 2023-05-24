//
//  KakaoMapVCWrapper.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//
import Foundation
import UIKit
import SwiftUI



struct KakaoMapVCWrapper: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        return KakaoMapVC()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
// MTMapPont - geoCoord를 쓴다. WGS84 형식
struct KakaoMapViewWrapper: UIViewRepresentable{
    @Binding var zoomLevel: Int
    @Binding var center: Geo
    @Binding var address: String?
    func makeUIView(context: Context) -> KakaoMapUIView {
        let kakaoMapView = KakaoMapUIView()
//        kakaoMapView.setZoomLevel(MTMapZoomLevel(zoomLevel), animated: false)
        //37.603406 127.142995
        kakaoMapView.setMapCenter(MTMapPoint(geoCoord: .init(geo: center)),
                                  zoomLevel: MTMapZoomLevel(zoomLevel),
                                  animated: false)
        context.coordinator.mapView = kakaoMapView
        kakaoMapView.delegate = context.coordinator
        return kakaoMapView
    }
    
    typealias UIViewType = KakaoMapUIView
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(zoomLevel: $zoomLevel,center: $center,address: $address)
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    final class MapCoordinator:NSObject,MTMapViewDelegate,MTMapReverseGeoCoderDelegate{
        var mapView: KakaoMapUIView?
        lazy var geocoder: MTMapReverseGeoCoder? = nil
        @Binding var zoomLevel:Int
        @Binding var center: Geo
        @Binding var address: String?
        
        init(zoomLevel: Binding<Int>,center: Binding<Geo>,address: Binding<String?>) {
            _zoomLevel = zoomLevel
            _center = center
            _address = address
        }
        func mapView(_ mapView: MTMapView!, zoomLevelChangedTo zoomLevel: MTMapZoomLevel) {
            self.zoomLevel = Int(zoomLevel)
            
        }
        func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
            self.center = mapCenterPoint.mapPointGeo().getGeo
            guard let apiKey:String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else{
                print("apiKey 가져오기 실패")
                return
            }
            let geoCoder = MTMapReverseGeoCoder(mapPoint: mapCenterPoint, with: self, withOpenAPIKey: apiKey)
            self.geocoder = geoCoder
            geoCoder?.startFindingAddress()
        }
        
        func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
            guard let addressString = addressString else { return }
            address = addressString
        }
    }
}

class KakaoMapUIView: MTMapView{
    init(){
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
}
class KakaoMapVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MTMapView(frame: self.view.frame)
//        mapView.delegate = self
        mapView.baseMapType = .hybrid
        self.view.addSubview(mapView)
    }
}

extension MTMapPointGeo{
    var getGeo:Geo {
        return (self.latitude,self.longitude)
    }
    init(geo: Geo){
        self.init(latitude: geo.latitude, longitude: geo.longtitude)
    }
}
