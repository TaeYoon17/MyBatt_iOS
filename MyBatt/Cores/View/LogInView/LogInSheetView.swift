//
//  LogInSheetView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/23.
//

import SwiftUI

struct SignUpSheetView: View {
    @State private var userEmail = ""
    @State private var username = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var showCheckPassword = false
    @State private var showPassword = false
    @State private var isSignUp = false
    var body: some View {
        VStack{
            self.userInputField
            VStack{
                Button {
                    print("회원가입 버튼")
                } label: {
                    HStack{
                        Spacer()
                        Text("회원가입").font(.headline).bold().foregroundColor(.white)
                        
                        Spacer()
                    }.padding(.vertical,8)
                }
                .buttonStyle(
                    .borderedProminent)
                .tint(.accentColor.opacity(isSignUp ? 1:0.2))
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .padding()
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
                    HStack {
                        Image(systemName: "")
                            .foregroundColor(.secondary)
                        //                        .imageScale(.large)
                        if showCheckPassword {
                            TextField("비밀번호를 다시 입력해주세요.",
                                      text: $checkPassword)
                            .frame(height:20)
                        } else {
                            SecureField("비밀번호를 다시 입력해주세요.",
                                        text: $checkPassword)
                            .frame(height:20)
                        }
                        Button(action: { self.showCheckPassword.toggle()}) {
                            Image(systemName: self.showCheckPassword ? "eye" : "eye.slash.fill")
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
            //MARK: -- 이름 그룹
            GroupBox{
                HStack {
                    Image(systemName: "")
                        .foregroundColor(.secondary)
                    TextField("이름을 입력해주세요.",
                              text: $username)
                }.padding()
                    .modifier(BorderModifier(paddingSize: 0))
            }label:{
                self.fieldLabel("이름")
            }
            .groupBoxStyle(GroupBoxBackGround(color: .white))
        }
    }
}
extension SignUpSheetView{
    func fieldLabel(_ str: String)-> some View{
        HStack{
            Text(str).font(.subheadline)
            Spacer()
        }
    }
}


struct SignUpSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpSheetView()
    }
}
