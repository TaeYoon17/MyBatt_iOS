//
//  MapFilterView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import SwiftUI

struct MapFilterView: View {
    @EnvironmentObject var mainVM: MapMainVM
    @StateObject var vm = MapFilterVM()
    @State var isPresent = true
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing: 8){
                HStack(spacing: 8){
                    Text("주변 병해 필터").font(.title.weight(.black))
                    Spacer()
                }.padding(.top)
            }
            CropDurationView()
                .environmentObject(vm)
                .padding(.bottom,8)
            textInfoView(label: "작물 선택", toggleState: $isPresent) {
                LazyVStack(spacing:8){
                    ForEach(vm.crops.indices,id:\.self){ idx in
                        if idx != vm.crops.endIndex-1{
                            CropSelectView(pageSheetCrop: $vm.crops[idx], myDiagnosis: $vm.mapDiseaseCnt[CropType(rawValue: vm.crops[idx].cropType) ?? .none])
                        }
                    }
                }.padding(.vertical,12)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
        .background(.white)
        .cornerRadius(20)
        //            내부 뷰에 cornerradius를 주고 꽉차게 만드려면 넣어줘야함
        .ignoresSafeArea(.all,edges: .bottom)
        .background(.thickMaterial)
        .ignoresSafeArea(.all,edges: .bottom)
        .onAppear(){
            mainVM.isPresent = false
            vm.addSubscribers(mainVM: mainVM)
        }
    }
}
extension MapFilterView{
    @ViewBuilder
    func textInfoView(label:String,toggleState: Binding<Bool>,
                      @ViewBuilder _ view:@escaping (() -> some View))-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            view()
        } label: {
            HStack{
                Text(label)
                    .font(.title3.weight(.bold))
                    
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(8)
    }
}
struct MapFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MapFilterView().environmentObject(MapMainVM())
    }
}
