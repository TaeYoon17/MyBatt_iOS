//
//  DiagnosisView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import SwiftUI
import PopupView
struct DiagnosisView: View {
    let screenWidth = UIScreen.main.bounds.width
    @State private var isLoading = true
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var userVM: UserVM
    
    @Environment(\.dismiss) private var dismiss
    @State private var diagnosisResponse: DiagnosisResponse?
    @State private var isFailed = false
    @State var naviStackIdx = 0
    var body: some View {
        ZStack{
            //MARK: -- 여기 수정해야함!!
//            if isLoading{
            if false{
                self.loadingView
                    .onReceive(userVM.diagnosisFail) { str in
                        if let str = str{
                            print(str)
                            self.isFailed = true
                        }
                    }
                    .onReceive(userVM.diagnosisSuccess) { output in
                    print("진단 결과 onReceive!!")
                    if let output = output{
                        self.isLoading = false
                        print("진단 결과 onReceive!!")
                        diagnosisResponse = output
                    }
                }
            }else{
                ZStack{
                    NavigationLink {
                        DiagnosisDetailView()
                    } label: {
                        EmptyView()
                    }
                    DiagnosisResultView(image: userVM.diagnosisImage!, response: diagnosisResponse)
                        .navigationTitle("병해 진단 결과")
//                        .onReceive(diagnosisVM.requestInfoSuccess) { output in
//                            self.naviStackIdx = appManager.linkAction()
//                            print("진단 결과를 받았습니다!!")
//                        }
                        .onDisappear(){
                            appManager.isDiagnosisActive = false
                            appManager.isTabbarHidden = false
                        }
                }
            }
        }.alert(isPresented: $isFailed) {
            Alert(title: Text("사진 똑바로 찍으세요"),dismissButton: .default(Text("돌아가기"),action: {
                appManager.goRootView()
            }))
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now()+10){
                if self.isLoading{
                    self.isFailed = true
                }
            }
        }
        .onDisappear(){
            appManager.isTabbarHidden = false
        }
    }
    var loadingView: some View{
        VStack(spacing:18){
            ProgressView {
                Text("병해 진단 중...")
            }
            Button("취소하고 돌아기기") {
                dismiss()
            }.buttonStyle(.bordered)
        }
    }
    var naviLinkController: some View{
        NavigationLink(isActive:appManager.getBindingStack(idx: naviStackIdx)){
            DiagnosisDetailView()
        } label: {
            EmptyView()
        }
        .isDetailLink(false)
    }
}

struct DiagnosisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiagnosisView().environmentObject(AppManager())
                .environmentObject(UserVM())
                .navigationTitle("wowworld")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
