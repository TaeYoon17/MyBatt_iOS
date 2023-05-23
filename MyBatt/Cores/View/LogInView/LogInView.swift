//
//  LogInView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var appManager: AppManager
    @State private var emailInput = ""
    @State private var passwordInput = ""
    var body: some View {
        NavigationView {
            VStack(spacing:44){
                VStack(alignment:.leading,spacing:18){
                    HStack{
                        Text("로그인하고\n작물을 진단 해보세요.")
                        Spacer()
                    }
                    .font(.system(.largeTitle).bold())
                    Text("로그인이 필요한 서비스입니다.")
                        .font(.title3)
                        .foregroundColor(Color.secondary.opacity(1.2))
                        .bold()
                }
                Spacer()
                VStack{
                    HStack(spacing:8){
                        Spacer()
                        ImageAppeaerBtnView(labelText: "회원가입", iconName: "person.badge.plus", bgColor: .accentColor)
                        Spacer()
                        ImageAppeaerBtnView(btnAction:{
                            appManager.isLoginActive = true
                        },labelText: "로그인", iconName: "person.badge.key", bgColor: .blue)
                        Spacer()
                    }
                    .padding(.bottom)
                }
            }.padding()
                .overlay {
                    self.onboardView
                }
        }
        
    }
    var onboardView: some View{
        let items = ["작물 이미지를 촬영하여 병해 진단하기","내 주변 병해 발생 지도 보기","작물 진단 기록 관리","진단 결과에 대해 궁금한 점을 전문가에게\n질문하기"]
        return VStack(spacing:48){
            Image("logo_demo").resizable()
                .frame(width: appManager.screenWidth/2,height: appManager.screenWidth/2)
            VStack(alignment: .leading,spacing:8){
                ForEach(items,id:\.self){ str in
                    onboardItemView(str)
                }
            }
        }
    }
    func onboardItemView(_ str:String)-> some View{
        HStack(){
            Image(systemName: "checkmark.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .background(Circle().foregroundColor(.accentColor.opacity(0.15)))
            Text(str).font(.system(size: 18,weight: .medium, design: .rounded))
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView().environmentObject(AppManager())
    }
}
