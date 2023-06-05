//
//  DiagnosisResultView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/05.
//

import SwiftUI
struct DiagnosisResultView: View {
    let screenWidth = UIScreen.main.bounds.width
    let diagnosisImage: Image
    let diagnosisResponse: DiagnosisResponse?
    @StateObject var diagnosisVM: DiagnosisVM = DiagnosisVM()
    @State private var expertMessageActive = false
    @State private var goToNextView = false
    var body: some View{
        ZStack{
            NavigationLink(isActive: $goToNextView) {
                DiseaseInfoView()
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
                                diagnosisImage
                                    .resizable()
                                    .padding(.horizontal)
                                    .frame(width: screenWidth)
                                    .clipped()
                            }
                    }
                    diagnosisBody
                        .padding(.horizontal)
                        .onReceive(self.diagnosisVM.tempInfoSuccess) { output in
                            self.goToNextView = true
                        }
                    Rectangle().frame(height: 120).foregroundColor(.white)
                }
            }
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
                                          diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "-1")
                        .environmentObject(self.diagnosisVM)
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
                                        DiagnosisInfoView(accuracy:result.accuracy ?? 0, diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "0")
                                            .environmentObject(self.diagnosisVM)
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
                    ExpertMailView().onDisappear(){
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
