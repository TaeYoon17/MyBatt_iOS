//
//  DiagnosisView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import SwiftUI

struct DiagnosisView: View {
//    @EnvironmentObject var appManager: AppManager
    @State private var isLoading = true
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
        Text("진단 결과!!")
    }
}

struct DiagnosisView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisView().environmentObject(AppManager())
    }
}
