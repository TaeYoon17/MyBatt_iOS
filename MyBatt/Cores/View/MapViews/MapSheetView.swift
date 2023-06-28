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
    @State var isListShow = false
    @State var crops: [MapSheetCrop] = []
    var body: some View {
        VStack(spacing:8){
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
                    Image(systemName: isGPSOn ? "location.fill" : "location")
                }.buttonBorderShape(.roundedRectangle)
                    .padding()
                    .background(isGPSOn ? Color.secondary : .white)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing: 8){
                    HStack(spacing: 8){
                        Text("주변 병해 리스트").font(.title.weight(.black))
                        Spacer()
                    }.padding(.top)
                    HStack{
                        Spacer()
                        VStack(alignment:.trailing){
                            Text("기간: 20년 06월 26일 ~ 23년 06월 26일")
                            HStack(spacing: 0){
                                Text("선택 작물: ")
                                ForEach(crops){ cropItem in
                                    if cropItem.isOn{
                                        Text("\(cropItem.cropKorean) ")
                                    }
                                }
                            }
                        }.font(.subheadline)
                    }
                }
                ForEach(crops){ (cropItem:MapSheetCrop) in
                    if cropItem.isOn {
                        self.textInfoView(label: cropItem.cropKorean, toggleState: $isListShow) {
                            Rectangle()
                        }
                    }
//                        if let diseaseItems = vm.nearDiseaseItems?[cropType]{
//                            self.textInfoView(label: Crop.koreanTable[cropType] ?? ""
//                                              , toggleState: $isListShow) {
//                                LazyVStack{
//                                    ForEach(0...100,id:\.self){idx in
//                                        Rectangle()
//                                    }
//                                }
//                            }
//                        }
                }
                
                
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(20)
            .ignoresSafeArea(.all,edges: .bottom)
        }
        .padding(.vertical)
//        .onRe(of: mainVM.crops, perform: { newValue in
//            self.crops = newValue
//        })
        .onReceive(mainVM.$crops, perform: { output in
            self.crops = output
        })
        .onChange(of: isGPSOn, perform: { newValue in
            mainVM.passthroughIsGPSOn.send(newValue)
        })
        .background(.thickMaterial)
        .ignoresSafeArea(.all,edges: .bottom)
        .onAppear(){
            vm.addSubscribers(mainVM: mainVM)
        }
    }
}
//MARK: -- 지도 시트 정보용 subscribers
extension MapSheetVM{
    func addSubscribers(mainVM: MapMainVM){
//        값을 전달해주는 역할
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
//        Response 받음
        mainVM.passthroughNearDiseaseItems.sink {[weak self] val in
            guard let _self = self else { return }
            _self.nearDiseaseItems = val
        }.store(in: &subscription)
        
    }
}

extension MapSheetView{
    @ViewBuilder
    func textInfoView(label:String,toggleState: Binding<Bool>,
                      @ViewBuilder _ view:@escaping (() -> some View))-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            view()
        } label: {
            HStack{
                Text(label)
                    .font(.title2.weight(.semibold))
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(8)
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView(isGPSOn: .constant(false))
            .environmentObject(MapMainVM())
            .environmentObject(MapSheetVM())
    }
}
