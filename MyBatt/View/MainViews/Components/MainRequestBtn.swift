//
//  MainRequestBtnView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/14.
//

import SwiftUI

struct MainRequestBtn: View {
    let labelImage: String
    let labelText: String
    let linkAction:()->()
    var body: some View {
        Button{
            linkAction()
        } label:{
            RoundedRectangle(cornerRadius: 10).foregroundColor(.lightGray)
                .overlay(HStack{
                    Image(systemName: self.labelImage)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 24))
                    Spacer()
                    Text(self.labelText)
                        .font(.system(size: 14,weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }.padding(.horizontal),alignment: .center)
        }
    }
}

struct MainRequestBtn_Previews: PreviewProvider {
    static var previews: some View {
        MainRequestBtn(labelImage: "questionmark.circle.fill", labelText: "전문가 질의 응답 받기 입니다"){
            print("MainRequestBtn")
        }
            .frame(width: 200,height:80)
    }
}
