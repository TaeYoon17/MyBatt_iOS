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
    @State private var myId = ""
    @State private var password = ""
    @State private var showPassword = false
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        Form {
            Section{
                HStack{
                    Text("아이디: ").frame(width: 60,alignment: .leading)
                        .font(.subheadline)
                    TextField("입력하세요", text: $myId)
                    Spacer()
                }
                HStack(spacing:0){
                    Text("비밀번호: ").frame(width: 60,alignment: .leading)
                        .font(.subheadline)
                    HStack {
                        Image(systemName: "")
                            .foregroundColor(.secondary)
                        if showPassword {
                            TextField("입력하세요",
                                      text: $password)
                        } else {
                            SecureField("입력하세요",
                                        text: $password)
                        }
                        Button(action: { self.showPassword.toggle()}) {
                            Image(systemName: self.showPassword ? "eye" : "eye.slash.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .background(Color.white)
                }
                HStack{
                    Spacer()
                    Button{
                        print("수정합니다.")
                    }label: {
                        Text("정보 수정").font(.headline)
                            .foregroundColor(.red)
                    }

                }
                    .padding(.vertical,4)
            } header: {
                Text("내 정보")
            }
            //            .listRowSeparatorTint(.clear)
            
            Section {
                HStack{
                    Text("알림")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundColor(.secondary)
                        
                }
                HStack{
                    Text("문의하기")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundColor(.secondary)
                }
            }header: {
                Text("앱 정보")
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
        .navigationTitle("마이 페이지")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            UITableView.appearance().backgroundColor = .clear
        }
    }
}

struct InfoMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            InfoMainView().environmentObject(AppManager())
                .environmentObject(UserVM())
        }
    }
}
