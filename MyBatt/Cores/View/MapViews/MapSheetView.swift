//
//  MapSheetView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/15.
//

import SwiftUI

enum LocationType{
    case Stop
    case Searching
}


struct MapSheetView: View {
    @EnvironmentObject var mainVM: MapMainVM
    @EnvironmentObject var vm: MapSheetVM
    @Binding var isGPSOn: Bool
    @State var isPresent = false
    @State var searchLocation = ""
    var body: some View {
        VStack{
            HStack{
                TextField("예) 광진구 능동로 209 - 초성 검색", text: $searchLocation)
                    .padding(.vertical, 10)
                    .padding(.horizontal).background {
                        RoundedRectangle (cornerRadius: 10,style: .continuous)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.black)
                    .onSubmit {
                        print(searchLocation)
                        vm.requestLocation(query: searchLocation)
                        searchLocation = ""
                    }
                Button{
                    isGPSOn.toggle()
                }label: {
                    Image(systemName: isGPSOn ?? false ? "location.fill" : "location")
                }.buttonBorderShape(.roundedRectangle)
                    .padding()
                    .background(isGPSOn ?? false ? Color.secondary : .white)
                    .clipShape(Circle())
            }
            ScrollView(.vertical,showsIndicators: false){
                Text("Hello world!!")
            }
        }
        .onChange(of: isGPSOn, perform: { newValue in
            mainVM.passthroughIsGPSOn.send(newValue)
        })
        .padding()
        .background(.thickMaterial)
        .onAppear(){
            vm.addSubscribers(mainVM: mainVM)
        }
    }
}

extension MapSheetVM{
    func addSubscribers(mainVM: MapMainVM){
        mapQueryDataService.$queryResult.sink { model in
            if let result = model?.documents?.first{
                guard let x: Double = Double(result.x ?? "") else { return }
                guard let y: Double = Double(result.y ?? "") else { return }
                let geo: Geo = Geo(y,x)
                print("쿼리 서비스에서 받은 geo: \(geo)")
//                centerPassthrough.send(geo)
                mainVM.passthroughCenter.send(geo)
            }
        }.store(in: &subscription)
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView(isGPSOn: .constant(false))
    }
}
