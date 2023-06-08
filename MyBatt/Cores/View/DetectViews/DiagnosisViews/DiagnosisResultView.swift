//
//  DiagnosisResultView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/05.
//

import SwiftUI
import Combine
import PopupView
struct DiagnosisResultView: View {
    enum ViewType{
        case Management
        case Response
    }
    private let screenWidth = UIScreen.main.bounds.width
    let diagnosisImage: Image
    let asynImageString: String
    let diagnosisResponse: DiagnosisResponse?
    let type: ViewType
    @StateObject var expertSheetVM: ExpertSheetVM = ExpertSheetVM()
    @State private var expertMessageActive = false
    @State private var goToNextView = false
    @State private var moreInfo:(String,Int)?
    init(image: Image,response: DiagnosisResponse?){
        self.diagnosisImage = image
        self.asynImageString = ""
        self.diagnosisResponse = response
        self.type = .Response
    }
    init(response:DiagnosisResponse?){
        self.diagnosisImage = Image("logo_demo")
        self.asynImageString = response?.imagePath ?? ""
        self.diagnosisResponse = response
        self.type = .Management
    }
    var body: some View{
        ZStack{
            NavigationLink(isActive: $goToNextView) {
                DiseaseInfoView(sickKey: self.moreInfo?.0 ?? "",
                                sickName:
                                    Diagnosis.koreanTable[
                                        DiagnosisType(rawValue: self.moreInfo?.1 ?? -1) ?? .none
                                    ] ?? ""
                                ,
                                cropName: Crop.koreanTable[CropType(rawValue: diagnosisResponse?.cropType ?? -1) ?? .none] ?? ""
                )
            } label: {
                EmptyView()
            }
            ScrollView(showsIndicators: false){
                VStack(spacing:8){
                    ZStack{
                        Rectangle()
                            .fill(.thickMaterial)
                            .frame(width: screenWidth,height:screenWidth/1.2)
                            .overlay {
                                //MARK: -- 이미지 표시하기
                                switch type{
                                case .Management:
                                    AsyncImage(url:URL(string: self.asynImageString)){ phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(1,contentMode: .fit)
                                                .cornerRadius(8)
                                        case .failure:
                                            self.diagnosisImage
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(8)
                                        @unknown default:
                                            // Since the AsyncImagePhase enum isn't frozen,
                                            // we need to add this currently unused fallback
                                            // to handle any new cases that might be added
                                            // in the future:
                                            EmptyView()
                                        }
                                    }
                                case .Response:
                                    diagnosisImage
                                        .resizable()
                                        .padding(.horizontal)
                                        .frame(width: screenWidth)
                                        .clipped()
                                }
                            }
                    }
                    diagnosisBody
                        .padding(.horizontal)
                        
                    Rectangle().frame(height: 120).foregroundColor(.white)
                }
            }
        }.popup(isPresented: $expertSheetVM.isSendCompleted) {
            Text("요청을 전송했어요!!")
                .font(.subheadline).bold()
                .padding()
                .background(.white)
                .clipShape(Capsule())
                .background(Capsule().stroke(lineWidth:3).foregroundColor(.black))
        } customize: {
            $0.type(.floater())
                .position(.top).dragToDismiss(true).autohideIn(2)
        }

    }
    var diagnosisBody: some View{
        VStack(spacing:8){
            HStack(alignment:.bottom){
                Text(Crop.koreanTable[CropType(rawValue: self.diagnosisResponse?.cropType ?? -1)!] ?? "진단 실패")
                    .font(.headline.bold())
                    .padding(.horizontal,8)
                    .padding(.vertical,4)
                    .foregroundColor(.white)
                    .background(Color.accentColor.opacity(0.6))
                    .cornerRadius(8)
                Text(Date.changeDateFormat(dateString: self.diagnosisResponse?.regDate ?? "날짜 정보 없음")).font(.callout)
                    .padding(.bottom,2)
                Spacer()
            }
                //MARK: -- 가장 유사한 결과
                GroupBox {
                    if let result = self.diagnosisResponse?.diagnosisResults?[0]{
                        DiagnosisInfoView(accuracy:result.accuracy ?? 0,
                                          diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "-1"){
                            self.moreInfo = (result.sickKey ?? "",result.diseaseCode ?? -1)
                            self.goToNextView = true
                        }
                    }
                } label: {
                    Text("가장 유사한 결과")
                }.bgColor(.white,paddingSize: 4)
                //MARK: -- 다른 유사 결과
                GroupBox {
                    LazyVStack{
                        if let results: [DiagnosisItem] = self.diagnosisResponse?.diagnosisResults{
                            ForEach(results){ result in
                                if let first = results.first{
                                    if result.id != first.id{
                                        DiagnosisInfoView(accuracy:result.accuracy ?? 0, diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "0"){
                                            self.moreInfo = (result.sickKey ?? "",result.diseaseCode ?? -1)
                                            self.goToNextView = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("다른 유사 결과")
                }.bgColor(.white,paddingSize: 4)
                
                GroupBox{
                    Button{
                        self.expertMessageActive = true
                    }label:{
                        HStack{
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 18,weight: .semibold))
                                .imageScale(.large)
                                .padding(.trailing,4)
                            Text("진단 결과에 대해 더 궁금한게 있다면?\n전문가에게 질문을 남겨보세요!")
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing,12)
                        }
                        .padding()
                        .foregroundColor(.accentColor)
                        .font(.subheadline)
                        .background(Color.accentColor.opacity(0.08))
                    }.modifier(DiagnosisInfoViewModifier(paddingSize: 0))
                }.bgColor(.white,paddingSize: 4)
                .sheet(isPresented: self.$expertMessageActive) {
                    ExpertMailView(diagnosisResponse: self.diagnosisResponse)
                        .environmentObject(expertSheetVM)
                        .onDisappear(){
                        self.expertMessageActive = false
                    }
                }
        }
    }
}

struct DiagnosisResultView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisView().environmentObject(UserVM())
    }
}
