//
//  DiagnosisView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import SwiftUI

struct DiagnosisView: View {
    //    @EnvironmentObject var appManager: AppManager
    let screenWidth = UIScreen.main.bounds.width
    @State private var isLoading = false
    var body: some View {
        if isLoading{
            self.loadingView
        }else{
            self.diagnosisView.navigationTitle("병해 진단 결과")
        }
    }
    
    var loadingView: some View{
        VStack{
            ProgressView {
                Text("병해 진단 중입니다.")
            }
            Button("취소하고 돌아기기") {
                print("Cancel Called!!")
            }
        }
    }
    var diagnosisView: some View{
        ScrollView(showsIndicators: false){
            VStack(spacing:8){
                ZStack{
                    Rectangle()
                        .fill(.thickMaterial)
                        .frame(width: screenWidth,height:screenWidth/1.2)
                        .overlay {
                            Image("picture_demo")
                                .resizable()
                                .padding(.horizontal)
                                .frame(width: screenWidth)
                                .clipped()
                        }
                }
                diagnosisBody
                    .padding(.horizontal)
                Rectangle().frame(height: 160).foregroundColor(.white)
            }
        }
    }
    var diagnosisBody: some View{
        VStack(spacing:8){
            HStack(alignment:.bottom){
                Text("고추")
                    .font(.headline.bold())
                    .padding(.horizontal,8)
                    .padding(.vertical,4)
                    .foregroundColor(.white)
                    .background(Color.accentColor.opacity(0.6))
//                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                Text("2023.05.11 05:52").font(.callout)
                    .padding(.bottom,2)
                Spacer()
            }
//            ScrollView(showsIndicators: true) {
                //MARK: -- 가장 유사한 결과
                GroupBox {
                        DiagnosisInfoView()
                } label: {
                    Text("가장 유사한 결과")
                }.bgColor(.white,paddingSize: 4)
                    
                //MARK: -- 다른 유사 결과
                GroupBox {
                    LazyVStack{
                        DiagnosisInfoView()
                        DiagnosisInfoView()
                    }
                } label: {
                    Text("다른 유사 결과")
                }.bgColor(.white,paddingSize: 4)
                
                GroupBox{
                    Button{
                        print("전문가 결과 보여주기")
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
//            }
        }
    }
}

struct DiagnosisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiagnosisView().environmentObject(AppManager())
                .navigationTitle("wowworld")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
