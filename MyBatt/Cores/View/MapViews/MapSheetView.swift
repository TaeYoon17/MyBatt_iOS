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
    @State var isToggleCrops: [Bool] = []
    @State var selectDate: Date?
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
                        VStack(alignment:.trailing,spacing: 8){
                            Text("기간: \(selectDate?.getKoreanString ?? "") ~ \(Date().getKoreanString)")
                                .font(.headline)
                            HStack(spacing: 0){
                                if crops.count == 0{
                                    Text("필터에서 작물을 선택하세요.").fontWeight(.medium)
                                }
                                else{
                                    Text("선택 작물: ").font(.headline)
                                    ForEach(crops){ cropItem in
                                        if cropItem.isOn{
                                            Text("\(cropItem.cropKorean) ")
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                ForEach(crops.indices, id: \.self){ idx in
                    let cropItem:MapSheetCrop = crops[idx]
                    if cropItem.isOn {
                        let cropType: CropType = CropType(rawValue: cropItem.cropType) ?? .none
                        self.textInfoView(label: "\(cropItem.cropKorean)-\(vm.nearDiseaseItems?[cropType]?.count ?? 0)개", toggleState: $isToggleCrops[idx]) {
                            if let items:[MapDiseaseResponse] = vm.nearDiseaseItems?[cropType]{
                                LazyVStack(spacing: 8){
                                    ForEach(items) { item in
                                        let date:String = Date.changeDateFormat(dateString: item.diagnosisRecord.regDate)
                                        MapItemView(item: CM_GroupItem(id: item.id,
                                                                       imgPath: item.diagnosisRecord.imagePath,
                                                                       address: "",
                                                                       regDate: date,
                                                                       cropType: cropType,
                                                                       diseaseType: DiagnosisType(rawValue: item.diseaseCode ?? -1) ?? DiagnosisType.none,
                                                                       accuracy: item.accuracy,
                                                                       geo: (item.diagnosisRecord.userLatitude,item.diagnosisRecord.userLongitude)
                                                                      ))
                                    }
                                }
                            }else{
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(20)
            .ignoresSafeArea(.all,edges: .bottom)
        }
        .padding(.vertical)
        .onReceive(mainVM.$selectDate, perform: { newValue in
            self.selectDate = newValue
        })
        .onReceive(mainVM.$crops, perform: { output in
            self.crops = output
            self.isToggleCrops = Array(repeating: false, count: output.count)
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
struct ItemGeo:Equatable{
    static func == (lhs: ItemGeo, rhs: ItemGeo) -> Bool {
        lhs.geo.latitude == rhs.geo.latitude && lhs.geo.longtitude == rhs.geo.longtitude
    }
    
    let geo: Geo
}
struct MapItemView:View{
    let item: CM_GroupItem
    var bgColor: Color = .white
    @State private var location = ""
    var body: some View{
        HStack(spacing: 16){
            AsyncImage(url: URL(string: item.imgPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading,spacing: 4){
                HStack{
                    Text(Crop.koreanTable[item.cropType] ?? "").font(.headline)
                    Text(item.regDate).font(.subheadline)
                    Spacer()
                }.padding(.top,4)
                HStack{
                    Text("병해:").font(.headline)
                    Text("\(Diagnosis.koreanTable[item.diseaseType] ?? "")").font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }.minimumScaleFactor(0.8)
                HStack(alignment: .top){
                    Text("위치:").font(.subheadline).bold()
                    Text(location)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }.minimumScaleFactor(0.8)
                Spacer()
                HStack(alignment: .top){
                    Spacer()
                    Text("\(Int(item.accuracy * 100))%").font(.subheadline)
                }.padding(.bottom,4)
                    .padding(.trailing,8)
            }
        }
        .onChange(of: item, perform: { newValue in
            Task{
                
                location = await LocationService.shared.requestAddressAsync(geo: newValue.geo)
            }
        })
        .task {
            print("아이템 뷰에서 받은 위치")
            location = await LocationService.shared.requestAddressAsync(geo: item.geo)
        }
        .background(bgColor)
        .frame(height: 100)
        .cornerRadius(8)
    }
}
