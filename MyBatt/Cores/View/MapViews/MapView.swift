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
                        DispatchQueue.main.async{
                            vm.tappedItem = item
                        }
                    }
            }
        }
        .onReceive(self.mainVM.passthroughCenter, perform: { output in
            print("self.mainVM.passthroughCenter, perform: { output in")
            self.vm.region.center = CLLocationCoordinate2D(geo: output)
        })
        .onReceive(self.mainVM.passthroughIsGPSOn, perform: { output in
            print("MapView isGPSOn onReceive \(output)")
            self.vm.isGPSOn = output
        })
        .onReceive(self.mainVM.passthroughNearDiseaseItems, perform: { output in
            guard let output = output else { return }
            print("self.mainVM.passthroughDiseaseResult")
            self.vm.setMapItems(nearDiseaseItems: output)
            //            self.vm.getMarkerInfo(result: output)
        })
        .onTapGesture {
            if !mainVM.isPresent && vm.tappedItem == nil{
                DispatchQueue.main.async {
                    mainVM.isPresent = true
                }
            }
            vm.tappedItem = nil
        }
        .onAppear(){
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
        self.$center.sink { output in
            print("위치가 바뀜!! \(output)")
            DispatchQueue.main.async {
                mainVM.center = output
            }
        }.store(in: &subscription)
        let locationName: Published<String>.Publisher = self.$locationName
        locationName.sink { name in
            mainVM.locationName = name
        }.store(in: &self.subscription)
        self.$tappedItem.throttle(for: 0.2, scheduler: DispatchQueue.main, latest: true)
            .sink { output in
                mainVM.tappedItem = output
            }.store(in: &subscription)
    }
    func setMapItems(nearDiseaseItems:[CropType:[MapDiseaseResponse]]){
        let wow : [T] = nearDiseaseItems.reduce(into: []) { (partialResult, arg1) in
            let (key, value) = arg1
            let items: [T] = value.map{
                _ = $0.diagnosisRecord
                let diseaseType = DiagnosisType(rawValue: $0.diseaseCode ?? -1) ?? .none
                let dateStr = Date.changeDateFormat(dateString: $0.diagnosisRecord.regDate)
                let geo = Geo($0.diagnosisRecord.userLatitude,$0.diagnosisRecord.userLongitude)
                let info = CM_GroupItem(id: $0.id, imgPath: $0.diagnosisRecord.imagePath, address: "", regDate: dateStr, cropType: key, diseaseType: diseaseType, accuracy: $0.accuracy,geo: geo)
                return MapItem(geo: geo, info:info,
                               cropType: key, diseaseCode: diseaseType) as! T
            }
            partialResult.append(contentsOf: items)
        }
        self.items = wow
    }
}

