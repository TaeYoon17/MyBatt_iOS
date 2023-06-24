//
//  MapView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/22.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Combine

//struct Marker:Markerable{
//    var geo: Geo
//}

struct MapView: View {
    @EnvironmentObject var mainVM: MapMainVM
    @StateObject private var vm: MapVM<MapItem> = MapVM<MapItem>()
    @State private var isLocation = false
    @State private var isMarkerTapped = false
    var body: some View {
        Map(coordinateRegion: $vm.region,showsUserLocation: true ,annotationItems: vm.items){ item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(geo: item.geo)) {
                MarkerView(cropType: item.cropType)
                    .scaleEffect(vm.tappedItem == item ? 1 : 0.85)
                    .animation(.easeInOut(duration: 0.2), value: vm.tappedItem == item)
                    .onTapGesture {
                        print("marker tapped!!")
                        isMarkerTapped = true
                        vm.centerOnMarker(item)
                    }
            }
        }
        .onReceive(self.mainVM.passthroughCenter, perform: { output in
            self.vm.center = output
            self.vm.region.center = CLLocationCoordinate2D(geo: output)
        })
        .onReceive(self.mainVM.passthroughIsGPSOn, perform: { output in
            print("MapView isGPSOn onReceive \(output)")
            self.vm.isGPSOn = output
        })
        .onReceive(self.mainVM.passthroughDiseaseResult, perform: { output in
            print("self.mainVM.passthroughDiseaseResult")
            self.vm.getMarkerInfo(result: output)
        })
        .onTapGesture {
            mainVM.isPresent.toggle()
            DispatchQueue.main.async {
                if isMarkerTapped{
                    isMarkerTapped = false
                }else{
                    if vm.tappedItem != nil{
                        vm.tappedItem = nil
                    }
                }
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline:.now()+1) {
                mainVM.isPresent = true
            }
            vm.addSubscriber(mainVM: self.mainVM)
            vm.getNowLocation()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapVM<MapItem>())
    }
}
extension MapVM{
    func addSubscriber(mainVM: MapMainVM) {
        let center: Published<Geo>.Publisher = self.$center
        center.sink { geo in
            print("위치가 바뀜!! \(geo)")
            DispatchQueue.main.async {
                mainVM.center = geo
            }
        }.store(in: &self.subscription)
        let locationName: Published<String>.Publisher = self.$locationName
        locationName.sink { name in
            mainVM.locationName = name
        }.store(in: &self.subscription)
    }
    func getMarkerInfo(result:MapDiseaseResult?){
        if let res = result{
            var items :[T] = []
            res.results.forEach { (key,value) in
                if let val:[T] = value as? [T]{
                    items.append(contentsOf: val)
                }
            }
            self.items = items
        }
    }
}

