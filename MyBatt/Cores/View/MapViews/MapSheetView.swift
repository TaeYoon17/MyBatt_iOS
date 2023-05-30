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
    @EnvironmentObject var vm: MapSheetVM
    @State var isCustom: Bool = false
    @State var selectionIdx:Int = 2 {
        didSet {
            print("isChanged")
        }
    }
    @State var number:Int = 1
    @State var data:Date = Date()
    @State var isPresented = false
    @State var isPepper = false
    @State var slider = 76.0
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing: 15){
                HStack{
                    TextField(vm.locationName ?? "위치 정보가 없습니다.", text:.constant("") ).padding(.vertical, 10)
                        .padding(.horizontal).background {
                            RoundedRectangle (cornerRadius: 10,style: .continuous)
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.gray)
                    Button{
                        vm.isGPSOn!.toggle()
                    }label: {
                        Image(systemName: vm.isGPSOn! ? "location.fill" : "location")
                    }.buttonBorderShape(.roundedRectangle)
                    .padding()
                    .background(vm.isGPSOn! ? Color.secondary : .white)
                    .clipShape(Circle())
                }
                GroupBox {
                    ForEach(vm.crops.indices,id:\.self){ idx in
                        if idx != vm.crops.endIndex-1{
                            CropSelectView(pageSheetCrop: $vm.crops[idx], myDiagnosis: $vm.mapDiseaseCnt[CropType(rawValue: vm.crops[idx].cropType) ?? .none])
                        }
                    }
                } label: {
                    Text("작물 이름")
                }.bgColor(.white)
                CropDurationView().environmentObject(vm)
            }.padding()
        }
        .background(.thickMaterial)
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView()
    }
}
