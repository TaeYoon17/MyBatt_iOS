//
//  MainSearchBtn.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/28.
//

import SwiftUI



struct MainSearchBtn: View {
    var linkAction:()->()
    var body: some View {
        Button {
            linkAction()
        } label:{
            HStack{
                Text("병해 정보 검색하기")
                    .font(.title2.weight(.bold))
                Spacer()
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .font(Font.title2.weight(.bold))
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct MainSearchBtn_Previews: PreviewProvider {
    static var previews: some View {
        MainSearchBtn(linkAction: {
            print("병해 정보 검색하기 버튼")
        })
    }
}
