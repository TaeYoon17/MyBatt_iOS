//
//  DiagnosisInfoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import SwiftUI

struct DiagnosisInfoView: View {
    let diagnosisName: String = "고추 점무늬병"
    let accuracy: Int = 86
    var body: some View {
        HStack{
            VStack(alignment: .leading,spacing:8){
                Text("병명: ").bold()+Text(diagnosisName)
                Text("일치율: ").bold()+Text("\(accuracy)%")
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

struct DiagnosisInfoViewModifier: ViewModifier{
    let paddingSize: CGFloat
    func body(content: Content) -> some View {
        content.padding(.all,paddingSize)
            .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .foregroundColor(.gray.opacity(0.3))
        )
        .font(.subheadline)
    }
    
}

struct DiagnosisInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisInfoView()
    }
}
