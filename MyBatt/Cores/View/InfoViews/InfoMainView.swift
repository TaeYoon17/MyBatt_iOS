//
//  InfoMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/05.
//

import SwiftUI

struct InfoMainView: View {
    @EnvironmentObject var appManager:AppManager
    @EnvironmentObject var userVM: UserVM
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        Form {
            Section {
                Text("Hello world")
            } header: {
                Text("내 정보")
            }
            
            Section {
                Button("로그아웃") {
                    print("로그아웃 실행")
                    appManager.goRootView()
                    userVM.logout()
                }.foregroundColor(.red)
                Button("회원 탈퇴"){
                    print("회원 탈퇴")
                }.foregroundColor(.red)
                    .font(.headline)
            }header: {
                Text("계정 설정")
            }
        }
        .background(Color.white)
        .onAppear(){
            UITableView.appearance().backgroundColor = .clear
        }
    }
}

struct InfoMainView_Previews: PreviewProvider {
    static var previews: some View {
        InfoMainView()
    }
}
