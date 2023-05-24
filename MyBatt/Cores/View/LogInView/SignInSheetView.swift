//
//  SignInSheetView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/23.
//

import SwiftUI

struct SignInSheetView: View {
    @EnvironmentObject var userVM: UserVM
    @State private var userEmail = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isSignIn = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView{
            VStack{
                self.userInputField
                VStack{
                    Button {
                        print("로그인 버튼")
                        userVM.login(email: "moviemaker@gmail.com", password: "gunja15")
                        self.dismiss()
                    } label: {
                        HStack{
                            Spacer()
                            Text("로그인").font(.headline).bold().foregroundColor(.white)
                            Spacer()
                        }.padding(.vertical,8)
                    }
                    .buttonStyle(
                        .borderedProminent)
                    .tint(.accentColor.opacity(isSignIn ? 1:0.2))
                    .buttonBorderShape(.roundedRectangle(radius: 12))
                    .padding()
                    Button{}label: {
                        Text("비밀번호 찾기")
                    }
                }
            }
        }
    }
    var userInputField: some View{
        VStack(spacing:0){
            //MARK: -- 이메일 그룹
            GroupBox {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                    //                        .imageScale(.large)
                    TextField("이메일을 입력해주세요.",
                              text: $userEmail).textContentType(.emailAddress)
                }.padding()
                    .modifier(BorderModifier(paddingSize: 0))
            } label: {
                self.fieldLabel("이메일")
            }
            .groupBoxStyle(GroupBoxBackGround(color: .white))
            //MARK: --  비밀번호 그룹
            GroupBox{
                VStack(spacing:16){
                    HStack {
                        Image(systemName: "")
                            .foregroundColor(.secondary)
                        //                        .imageScale(.large)
                        if showPassword {
                            TextField("비밀번호를 입력해주세요.",
                                      text: $password)
                            .frame(height:20)
                        } else {
                            SecureField("비밀번호를 입력해주세요.",
                                        text: $password)
                            .frame(height:20)
                        }
                        Button(action: { self.showPassword.toggle()}) {
                            Image(systemName: self.showPassword ? "eye" : "eye.slash.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .modifier(BorderModifier(paddingSize: 0))
                }
            }label:{
                self.fieldLabel("비밀번호")
            }
            .groupBoxStyle(GroupBoxBackGround(color: .white))
        }
    }
    func fieldLabel(_ str: String)-> some View{
        HStack{
            Text(str).font(.subheadline)
            Spacer()
        }
    }
    
}

struct SignInSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSheetView()
    }
}
