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
    var body: some View {
        HStack{
            VStack(alignment: .leading,spacing:8){
                Text("병명: ").bold()+Text(
                    Diagnosis.koreanTable[DiagnosisType(rawValue: diagnosisNumber) ?? .PepperNormal] ?? "알 수 없는 질병"
                )
                Text("일치율: ").bold()+Text("\(Int(accuracy*100))%")
            }
            Spacer()
            Button{
                // 여기에 바인딩하기
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
//        .cornerRadius(8)
        
            
    }
}



struct DiagnosisInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisInfoView(accuracy: 0.86, diagnosisNumber: 7)
    }
}
