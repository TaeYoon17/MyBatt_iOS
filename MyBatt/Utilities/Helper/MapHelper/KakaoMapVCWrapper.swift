//
//  KakaoMapVCWrapper.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//
import Foundation
import UIKit
import SwiftUI
// MTMapPont - geoCoord를 쓴다. WGS84 형식
struct KakaoMapViewWrapper: UIViewRepresentable{
    @Binding var zoomLevel: Int
    @Binding var center: Geo
    @Binding var address: String?
    @Binding var isTrackingMode: Bool?
    func makeUIView(context: Context) -> KakaoMapUIView {
        let kakaoMapView = KakaoMapUIView()
//        kakaoMapView.setZoomLevel(MTMapZoomLevel(zoomLevel), animated: false)
        //37.603406 127.142995
        kakaoMapView.baseMapType = .standard
        kakaoMapView.setMapCenter(MTMapPoint(geoCoord: .init(geo: center)),
                                  zoomLevel: MTMapZoomLevel(zoomLevel),
                                  animated: false)
        context.coordinator.mapView = kakaoMapView
        kakaoMapView.delegate = context.coordinator
        context.coordinator.addCircle(geo: center)
        return kakaoMapView
    }
    
    typealias UIViewType = KakaoMapUIView
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(zoomLevel: $zoomLevel,center: $center,address: $address,isTrackingMode: isTrackingMode)
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.isTrackingMode = self.isTrackingMode
    }
    final class MapCoordinator:NSObject,MTMapViewDelegate,MTMapReverseGeoCoderDelegate{
        var mapView: KakaoMapUIView?
        lazy var geocoder: MTMapReverseGeoCoder? = nil
        @Binding var zoomLevel:Int
        @Binding var center: Geo
        @Binding var address: String?
        var circles: [MTMapCircle] = []
        var centerCircle:MTMapCircle? = nil
        var isTrackingMode: Bool?{
            didSet{
                DispatchQueue.global(qos: .default).async {
                    if self.isTrackingMode == true{
                        self.mapView?.currentLocationTrackingMode = .onWithoutHeading
                    }else{
                        self.mapView?.currentLocationTrackingMode = .off
                    }
                }
                
            }
        }
        
        init(zoomLevel: Binding<Int>,center: Binding<Geo>,address: Binding<String?>,isTrackingMode:Bool?) {
            _zoomLevel = zoomLevel
            _center = center
            _address = address
            self.isTrackingMode = isTrackingMode

        }
        deinit{
            circles.forEach{
                mapView?.removeCircle($0)
            }
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
            self.removeCenterCircle()
            self.addCenterCircle()
            let geoCoder = MTMapReverseGeoCoder(mapPoint: mapCenterPoint, with: self, withOpenAPIKey: apiKey)
            self.geocoder = geoCoder
            if let geoCoder = self.geocoder{
                print("geoCoder 실행!!")
                geoCoder.startFindingAddress()
            }else{
                print("geoCoder 실행 실패!!")
            }
            
        }
        
        func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
//            print("주소 이름 변환 성공!!")
            guard let addressString = addressString else { return }
//            print(addressString)
            address = addressString
        }
        func addCircle(geo:Geo){
            let circle = MTMapCircle()
            circle.circleLineWidth = 2
            circle.circleFillColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.5)
            circle.circleRadius = 10
            circle.circleCenterPoint = MTMapPoint(geoCoord:MTMapPointGeo(latitude: geo.latitude, longitude: geo.longtitude))
            mapView?.addCircle(circle)
        }
        
    }

}
//MARK: -- 반경표시 Circle 만들기
extension KakaoMapViewWrapper.MapCoordinator{
    func addCenterCircle(){
//            self.centerCircle = nil
        let circle = MTMapCircle()
        circle.circleLineWidth = 1
        circle.circleLineColor = .lightGray
        circle.circleFillColor = UIColor(red: 0, green: 0.625, blue: 0.055, alpha: 0.6)
        circle.circleRadius = 32
        circle.circleCenterPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: center.latitude, longitude: center.longtitude))
        self.centerCircle = circle
        mapView?.addCircle(circle)
    }
    func removeCenterCircle(){
        mapView?.removeCircle(self.centerCircle)
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

extension MTMapPointGeo{
    var getGeo:Geo {
        return (self.latitude,self.longitude)
    }
    init(geo: Geo){
        self.init(latitude: geo.latitude, longitude: geo.longtitude)
    }
}
