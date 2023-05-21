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
            self.diagnosisView
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
        VStack(spacing:8){
            ZStack{
                Rectangle()
                    .fill(.thickMaterial)
                    .frame(width: screenWidth,height:screenWidth/1.2)
                    .overlay {
                        Image("picture_demo")
                            .resizable()
                            .frame(width: screenWidth/1.2)
                            .clipped()
                    }
            }
//                .background(Color.accentColor)
            diagnosisBody
                .padding(.horizontal)
            Spacer()
        }
    }
    var diagnosisBody: some View{
        VStack(spacing:8){
            HStack{
                Text("고추")
                    .font(.title2.bold())
                    .padding(.all,8)
                    .background(.blue)
                    .cornerRadius(15)
                Spacer()
            }.padding(.horizontal)
            ScrollView(showsIndicators: false) {
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
            }
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
