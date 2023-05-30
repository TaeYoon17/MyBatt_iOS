//
//  KakaoMapVCWrapper.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//
import Foundation
import UIKit
import SwiftUI
import Combine
import CoreLocation
// MTMapPont - geoCoord를 쓴다. WGS84 형식
struct KakaoMapViewWrapper: UIViewRepresentable{
    @Binding var zoomLevel: Int
    @Binding var center: Geo
    @Binding var address: String?
    @Binding var isTrackingMode: Bool?
    @Binding var mapDiseaseResult: MapDiseaseResult?
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
        DispatchQueue.global(qos: .default).async {
            kakaoMapView.currentLocationTrackingMode = .onWithoutHeading
        }
        
        //        context.coordinator.addCircle(geo: center)
        return kakaoMapView
    }
    
    typealias UIViewType = KakaoMapUIView
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(zoomLevel: $zoomLevel,center: $center,address: $address
                              ,isTrackingMode: isTrackingMode)
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if context.coordinator.isTrackingMode != self.isTrackingMode{
            context.coordinator.isTrackingMode = self.isTrackingMode
        }
        if let mapDiseaseResult = self.mapDiseaseResult{
            if mapDiseaseResult != context.coordinator.prevDiseaseResults{
                context.coordinator.prevDiseaseResults = mapDiseaseResult
                context.coordinator.makeDiseaseRange(mapDiseaseResponse: mapDiseaseResult.results)
            }
        }
        if let prevGeo = context.coordinator.prevGeo{
            if prevGeo != center{
                print("get와 center가 다름!!")
                context.coordinator.prevGeo = center
                context.coordinator.changeCenter()
            }
        }
    }
    
    
    final class MapCoordinator:NSObject,MTMapViewDelegate,MTMapReverseGeoCoderDelegate{
        var mapView: KakaoMapUIView?
        lazy var geocoder: MTMapReverseGeoCoder? = nil
        @Binding var zoomLevel:Int
        @Binding var center: Geo
        @Binding var address: String?
        var prevDiseaseResults: MapDiseaseResult?
        var prevGeo : Geo?
        var diseaseCircles:[CropType:[MTMapCircle]] = [.Lettuce : [],.Pepper:[],.StrawBerry:[],.Tomato:[]]
        var centerCircle:MTMapCircle? = nil
        var centerMarker:MTMapPOIItem? = nil
        var isMoving: Bool = false
        var isTrackingMode: Bool? = false{
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
        init(zoomLevel: Binding<Int>,center: Binding<Geo>,address: Binding<String?>
             ,isTrackingMode:Bool?) {
            _zoomLevel = zoomLevel
            _center = center
            _address = address
            self.isTrackingMode = isTrackingMode
            self.prevGeo = center.wrappedValue
        }
        deinit{
            self.removeAllCircles()
        }
        func mapView(_ mapView: MTMapView!, zoomLevelChangedTo zoomLevel: MTMapZoomLevel) {
            print("------- zoomLevel: MTMapZoomLevel) \(zoomLevel)!--------")
            self.zoomLevel = Int(zoomLevel)
            self.changeAllCircles(zoomLevel: Int(zoomLevel))
        }
        func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
//            if self.isMoving { return }
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
        func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, failedToFindAddressWithError error: Error!) {
            print("에러 발생!! \(error.localizedDescription)")
        }
        func mtMapReverseGeoCoder(_ rGeoCoder: MTMapReverseGeoCoder!, foundAddress addressString: String!) {
            //            print("주소 이름 변환 성공!!")
            guard let addressString = addressString else { return }
            //            print(addressString)
            address = addressString
        }
        
    }
    
}
//MARK: -- 반경표시 Circle 만들기
extension KakaoMapViewWrapper.MapCoordinator{
    func addCenterCircle(){
        let circle = MTMapCircle()
        circle.circleLineWidth = 1
        circle.circleLineColor = .lightGray
        circle.circleFillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        circle.circleRadius = Float(self.changeRadius())
        
        circle.circleCenterPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: center.latitude, longitude: center.longtitude))
        self.centerCircle = circle
        mapView?.addCircle(circle)
    }
    func removeCenterCircle(){
        mapView?.removeCircle(self.centerCircle)
    }
    func changeRadius()->Int{
        switch self.zoomLevel{
        case 1: return 32
        case 2: return 70
        case 3: return 160
        case 4: return 320
        case 5: return 700
        case 6: return 1200
        default: return  16
        }
    }
}

//MARK: -- 가져온 response값을 통해 원을 그리는 함수
extension KakaoMapViewWrapper.MapCoordinator{
    func makeDiseaseRange(mapDiseaseResponse: [CropType:[MapItem]]){
//        if isMoving { return }
        print("--------------makeDiseaseRange 함수 호출됨!!--------------")
        self.removeAllCircles()
        self.diseaseCircles = [.Lettuce : [],.Pepper:[],.StrawBerry:[],.Tomato:[]]
        DispatchQueue.main.async {
            for (key,val) in mapDiseaseResponse{
                for item in val{
                    let circle = self.makeCircle(geo: item.geo, cropType: item.cropType)
                    self.diseaseCircles[key]?.append(circle)
                }
            }
            self.drawAllCircles()
        }
    }
    func removeAllCircles(){
        for cropCircle in self.diseaseCircles{
            cropCircle.value.forEach { circle in
                if let mapView = self.mapView{
                    mapView.removeCircle(circle)
                }else{
                    print("mapView 안됨!!")
                }
            }
        }
    }
    func makeCircle(geo:Geo,cropType: CropType)->MTMapCircle{
        let circle = MTMapCircle()
        circle.circleLineColor = UIColor(red: 0, green: 0.625, blue: 0.055, alpha: 1)
        circle.circleRadius = Float(self.changeRadius())
        switch cropType{
        case .Lettuce:
            circle.circleFillColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.3)
        case .Pepper:
            circle.circleFillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
        case .StrawBerry:
            circle.circleFillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        case .Tomato:
            circle.circleFillColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.3)
        case .none: break
        }
        circle.circleCenterPoint = MTMapPoint(geoCoord:MTMapPointGeo(latitude: geo.latitude, longitude: geo.longtitude))
        return circle
    }
    func drawAllCircles(){
        for cropCircle in self.diseaseCircles{
            cropCircle.value.forEach { circle in
                if let mapView = self.mapView{
                    mapView.addCircle(circle)
                }else{
                    print("mapView 안됨!!")
                }
            }
        }
    }
    func changeAllCircles(zoomLevel: Int){
        for cropCircle in self.diseaseCircles{
            cropCircle.value.forEach { circle in
                circle.circleRadius = Float(self.changeRadius())
            }
        }
    }
}
//MARK: -- 위치를 바꾼다.
extension KakaoMapViewWrapper.MapCoordinator{
    func changeCenter(){
        DispatchQueue.main.async {
            self.isMoving = true
            print("func changeCenter\(self.center)")
            self.mapView?.setMapCenter(MTMapPoint(geoCoord: .init(latitude: self.center.latitude, longitude: self.center.longtitude)), animated: false)
            self.isMoving = false
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

extension MTMapPointGeo{
    var getGeo:Geo {
        return (self.latitude,self.longitude)
    }
    init(geo: Geo){
        self.init(latitude: geo.latitude, longitude: geo.longtitude)
    }
}
