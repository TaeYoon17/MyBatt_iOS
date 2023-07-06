//
//  ExpertMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import SwiftUI
fileprivate enum ExpertSheetType:Identifiable{
    var id:Self{
        return self
    }
    case Info
    case Request
}
struct ExpertMainView: View {
    @State var users = ["hello","my","name","is","life","good"]
    @State private var toggleStates = [true,true,true,true]
    @State private var isAdd = false
    @State private var sheetType: ExpertSheetType? = nil
    @StateObject private var vm:ExpertMainVM = ExpertMainVM()
    @State private var requestItem: ExpertSendModel?
    @State private var itemDiagnosis: DiagnosisResponse?
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 12){
                self.textInfoView(label: "요청 중인 메시지",toggleState: $toggleStates[1]){
                        LazyVStack(spacing:8){
                            ForEach(vm.unResponseItem.indices,id:\.self){ idx in
                                Button{
                                    self.requestItem = vm.unResponseItem[idx]
                                    self.itemDiagnosis = vm.unResponseDiagnosis[idx]
                                    self.sheetType = .Info
                                }label: {
                                    if vm.unResponseDiagnosis.count > idx,let diagnosis:DiagnosisResponse =  vm.unResponseDiagnosis[idx]{
                                        ListItem(imgString: diagnosis.imagePath ?? "",
                                                 title: vm.unResponseItem[idx].title ?? "",
                                                 disesName: diagnosis.diagnosisResults?[0].diseaseCode ?? -1,
                                                 cropName: diagnosis.cropType ?? -1,
                                                 accuracy: diagnosis.diagnosisResults?[0].accuracy ?? 0,
                                                 date: diagnosis.regDate ?? "날짜 정보가 없습니다")
                                    }else{
                                        ListItem(imgString: "",
                                                 title: vm.unResponseItem[idx].title ?? "",
                                                 disesName: -1,
                                                 cropName: -1,
                                                 accuracy: 0,
                                                 date: "날짜 정보가 없습니다")
                                    }
                                }.buttonStyle(.plain)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical,12)
                        .cornerRadius(8)
                    }
                self.textInfoView(label: "응답 온 메시지",toggleState: $toggleStates[3]){
                    LazyVStack(spacing:8){
                        ForEach(vm.responsedItem.indices,id:\.self){ idx in
                            Button{
                                self.requestItem = vm.responsedItem[idx]
                                self.itemDiagnosis = vm.responsedDiagnosis[idx]
                                self.sheetType = .Info
                            }label: {
                                if vm.responsedDiagnosis.count > idx,let diagnosis:DiagnosisResponse =  vm.responsedDiagnosis[idx]{
                                    ListItem(imgString: diagnosis.imagePath ?? "",
                                             title: vm.responsedItem[idx].title ?? "",
                                             disesName: diagnosis.diagnosisResults?[0].diseaseCode ?? -1,
                                             cropName: diagnosis.cropType ?? -1,
                                             accuracy: diagnosis.diagnosisResults?[0].accuracy ?? 0,
                                             date: diagnosis.regDate ?? "날짜 정보가 없습니다")
                                }else{
                                    ListItem(imgString: "",
                                             title: vm.unResponseItem[idx].title ?? "",
                                             disesName: -1,
                                             cropName: -1,
                                             accuracy: 0,
                                             date: "날짜 정보가 없습니다")
                                }
                            }.buttonStyle(.plain)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical,12)
                    .cornerRadius(8)
                }
                Rectangle().fill(Color.white).frame(height:100)
            }.padding(.all)
            //MARK: -- Sheet Router
                .sheet(item: $sheetType){ item in
                    switch item{
                    case .Info:
                        ExpertMsgView(sendModel: self.requestItem, diagnosis: self.itemDiagnosis)
                            .onDisappear(){
                                sheetType = nil
                            }
                    case .Request: ExpertMailView()
                            .environmentObject(ExpertSheetVM())
                            .onDisappear(){
                                sheetType = nil
                                self.vm.getList()
                            }
                    }
                }

                
        }
        .navigationBarBackground({
            Color.white
        })
        .navigationTitle("전문가 문의")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //MARK: -- 나중에 추가해야할 추가버튼
            ToolbarItem(placement: .navigationBarTrailing, content: {
                            Button{
                                self.sheetType = .Request
                            }label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        })
        }
        
    }
}
extension ExpertMainView{
    @ViewBuilder
    func textInfoView(label:String,toggleState: Binding<Bool>,
                      @ViewBuilder _ view:@escaping (() -> some View))-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            view()
        } label: {
            HStack{
                Text(label)
                    .font(.title2.weight(.bold))
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(8)
    }
}
struct ExpertMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMainView()
        }
        
    }
}
fileprivate struct ListItem: View{
    let imgString: String
    let title: String
    let disesName: Int
    let cropName: Int
    let accuracy: Double
    let date: String
    var body: some View{
        HStack(spacing: 16){
            AsyncImage(url:URL(string: self.imgString)){ phase in
                switch phase {
                case .empty:
                    Image("logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                case .failure:
                    Image("logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                @unknown default:
                    // Since the AsyncImagePhase enum isn't frozen,
                    // we need to add this currently unused fallback
                    // to handle any new cases that might be added
                    // in the future:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading,spacing: 4){
                HStack(alignment:.top){
                    Text("제목:").font(.headline)
                    Text(title).font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }.padding(.top,4)
                HStack(alignment:.top){
                    Text("병해:").font(.headline)
                    Text(Diagnosis.koreanTable[DiagnosisType(rawValue: disesName) ?? .none] ?? "")
                        .font(.subheadline)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\(Int(accuracy * 100))%").font(.subheadline)
                    Text("\(Crop.koreanTable[CropType(rawValue: cropName) ?? .none] ?? "")")
                    Text("\(Date.changeDateFormat(dateString: date))")
                }
                .font(.footnote)
                .padding(.trailing,8)
                .padding(.bottom,4)
                //                .background(Color.blue)
                
                
                //                Spacer()
            }
            
        }
        .background(Color.white)
        .frame(height: 100)
        
    }
}
