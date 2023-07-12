//
//  DiagnosisInfoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import SwiftUI

struct DiagnosisInfoView: View {
//    let diagnosisName: String = "고추 점무늬병"
//    let accuracy: Int = 86
    let accuracy: Double
    let diagnosisNumber: Int
    let code :String
    var completion:()->()
    var body: some View {
        HStack{
            VStack(alignment: .leading,spacing:8){
                Text("병명: ").bold()+Text(
                    DiagDisease.koreanTable[DiagDiseaseType(rawValue: diagnosisNumber) ?? .PepperNormal] ?? "알 수 없는 질병"
                )
                Text("일치율: ").bold()+Text("\(Int(accuracy*100))%")
            }
            Spacer()
            Button{
            //MARK: -- 여기에서 자세한 결과 요청을 보냄
//                self.diagnosisVM.tempInfo()
                completion()
            } label: {
                HStack{
                    Text("상세정보").font(.caption)
                    Image(systemName: "chevron.right").imageScale(.small)
                }
            }
            .modifier(DiagnosisInfoViewModifier(paddingSize: 8))
            .background(.thinMaterial)
            
        }
    .modifier(DiagnosisInfoViewModifier(paddingSize: 16))
    }
}



struct DiagnosisInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisInfoView(accuracy: 0.86, diagnosisNumber: 7,code:"5885"){
            print("Hello world")
        }
    }
}
