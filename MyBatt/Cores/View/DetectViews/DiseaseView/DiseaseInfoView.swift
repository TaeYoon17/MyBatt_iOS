//
//  DiseaseInfoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI
import Combine
private enum InfoType:CaseIterable{
    case PictureType
    case EnvironmentType
    case Symptom
}
struct DiseaseInfoView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) private var dismiss
    @State private var toggleStates = [true,true,true,true]
    @State private var goNextView = false
    @State private var imageWidth: CGFloat = 0
    @State private var errorMsg = ""
    @State private var isError = false
    @StateObject private var vm: DiseaseInfoVM
    let sickKey: String
    let sickName: String
    let cropName: String
    init(sickKey:String,sickName: String,cropName: String){
        self.sickKey = sickKey
        self.cropName = cropName
        self.sickName = sickName
        self._vm = StateObject(wrappedValue: DiseaseInfoVM(sickKey: sickKey))
    }
    var body: some View {
        VStack(spacing:0){
            NavigationLink(isActive: $goNextView) {
                GeometryReader{ proxy in
                    let topInset = proxy.safeAreaInsets.top
                    PesticideListView(topInset: topInset,cropName: self.cropName,sickName:self.sickName)
                }
            } label: {
                EmptyView()
            }
            //MARK: -- 헤더 뷰
            HStack(alignment:.center, spacing:4){
                ScrollView(.horizontal){
                    Text("\(cropName) \(sickName.replacingOccurrences(of: cropName, with: "").trimmingCharacters(in: .whitespaces))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            ScrollView(showsIndicators: false){
                let nonFound = "검색 결과가 없습니다."
                VStack(spacing: 12){
                    self.imageInfo
                    self.textInfoView(text: vm.diseaseInfoModel?.developmentCondition ?? nonFound, label: "발생환경",toggleState: $toggleStates[1])
                    self.textInfoView(text: vm.diseaseInfoModel?.symptoms ?? nonFound, label: "증상",
                                      toggleState: $toggleStates[2])
                    self.textInfoView(text: vm.diseaseInfoModel?.preventionMethod ?? nonFound, label: "방제방법",
                                      toggleState: $toggleStates[3])
                    Rectangle().fill(Color.white).frame(height:100)
                }.padding(.all)
            }
            
        }
        .onReceive(vm.errorMessage) { output in
            //            print("뷰 모델의 에러 감지")
            self.errorMsg = output
            self.isError = true
        }
        .alert(errorMsg,isPresented: $isError){
            Button("뒤로가기", role: .cancel) { self.dismiss() }
        }
        .padding(.vertical)
        .background(Color.white)
        .navigationTitle("병해정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                Button{
                    print("관련 농약 버튼 클릭!!")
                    self.goNextView = true
                }label: {
                    HStack(spacing:4){
                        Image(systemName: "cross.case")
                            .imageScale(.small)
                        Text("농약 정보")
                            .font(.system(size:16).weight(.semibold))
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.all,2)
                .background(Color.accentColor.opacity(0.8))
                .cornerRadius(8)
            }
        }
    }
}

//MARK: -- 사진 정보
extension DiseaseInfoView{
    var imageInfo: some View {
        DisclosureGroup(isExpanded: $toggleStates[0]) {
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    if let imageList = self.vm.diseaseInfoModel?.imageList{
                        ForEach(imageList){image in
                            AsyncImage(url: URL(string: image.imagePath ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(1,contentMode: .fit)
                                        .cornerRadius(8)
                                    // MARK: -- 선넘는 크기 조절하기
                                        .frame(maxHeight:400)
                                case .failure:
                                    Image(systemName: "logo_demo")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
            .background(GeometryReader{
                proxy in
                Color.clear.onAppear(){
                    self.imageWidth = proxy.size.width / 1.6
                    
                }
            })
            .padding(.all,8)
            .background(.white)
            .padding(.top,4)
            .cornerRadius(12)
            
        } label: {
            Text("사진정보").font(.title2.weight(.heavy))
        }
        .padding()
        .background(Color.lightGray)
        .cornerRadius(12)
    }
}
// MARK: -- 발생환경, 증상 뷰
extension DiseaseInfoView{
    @ViewBuilder
    func textInfoView(text:String,label:String,toggleState: Binding<Bool>)-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            HStack{
                Text(text)
                Spacer()
            }.padding(.all,12)
                .background(.white)
                .padding(.top,4)
                .cornerRadius(12)
        } label: {
            HStack{
                Text(label)
                    .font(.title2.weight(.heavy))
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(12)
        
    }
}
struct DiseaseInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiseaseInfoView(sickKey: "D00001545",sickName: "버거씨병", cropName: "토마토")
        }
    }
}
