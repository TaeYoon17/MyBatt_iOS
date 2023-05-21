//
//  LogInView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/19.
//

import SwiftUI

struct LogInView: View {
    @State private var emailInput = ""
    @State private var passwordInput = ""
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("로그인하고 작물을 진단 해보세요.")
                    Spacer()
                }
                .font(.system(.largeTitle).bold())
                .padding()
                Spacer()
                VStack{
                    Section(header: HStack{
                        Text("로그인 정보")
                        Spacer()
                    }, content: {
                        TextField("이메일", text: $emailInput).keyboardType(.emailAddress).autocapitalization(.none)
                        SecureField("비밀번호", text: $passwordInput).keyboardType(.default)
                    })
                    Section {
                        HStack{
                            Spacer()
                            Button(action: {
                                print("로그인 버튼 클릭")
                                //                    userVM.login(email: emailInput, password: passwordInput)
                            }, label: {
                                Text("로그인 하기")
                            })
                            Spacer()
                            Button{}label: {
                                Text("회원 가입하기")
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
            }
        }
        
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
