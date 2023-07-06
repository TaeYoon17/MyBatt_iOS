//
//  DiagnoisisMapView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/30.
//

import SwiftUI
import MapKit
struct DiagnoisisMapView: View {
    private struct Ann:Identifiable{
        var id = UUID()
        let geo:Geo
        let type:CropType
    }
    let geo:Geo
    @State private var annoItem: [Ann]
    @State private var isAppear = false
    init(geo: Geo,cropType: Int) {
        self.geo = geo
        let type = CropType(rawValue: cropType) ?? .none
        self._annoItem = State(wrappedValue: [Ann(geo: geo,type: type)])
    }
    @State private var location = ""
    var body: some View {
        let region = CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longtitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        return Map(coordinateRegion: .constant(MKCoordinateRegion(center: region, span: span)),
                   interactionModes: [],
                   showsUserLocation: false,
                   annotationItems:annoItem){ item in
            MapAnnotation(coordinate: region) {
                self.marker(type: item.type)
            }
        }
            .frame(height: 150)
            .overlay(alignment:.topTrailing){
                Text(location).font(.footnote.bold())
                    .padding(.all,6)
                    .background(.white.opacity(0.66))
                    .cornerRadius(8)
                    .padding(.all,6)
            }
            .onTapGesture {
                print("선택됨!!")
            }
            .task {
                self.location = await LocationService.shared
                    .requestAddressAsync(geo: self.geo)
            }.onAppear(){
                DispatchQueue.main.async {
                    self.isAppear.toggle()
                }
            }
    }
    @MainActor
    func marker(type:CropType)-> some View{
        VStack(spacing:0){
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 28,height: 28)
                .foregroundColor(.lightAmbientColor)
                .padding(4)
                .background(Color.accentColor)
                .clipShape(Circle())
                .overlay(alignment:.center) {
                    Text(Crop.iconTable[type] ?? "").font(.footnote)
                }
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.accentColor)
                .frame(width: 8,height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom,40)
        }.offset(y: isAppear ? 0 : -10)
            .animation(.easeInOut(duration: 0.5).repeatCount(5), value: isAppear)
    }
}

struct DiagnoisisMapView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnoisisMapView(geo: Geo(32.005,0), cropType: -1)
    }
}
