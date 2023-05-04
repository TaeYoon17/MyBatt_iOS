//
//  MainMapBtn.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/14.
//

import SwiftUI

struct MainMapBtn: View {
    @State private var isAppear: Bool = false
    let linkAction : ()->()
    var body: some View {
        Button{
            linkAction()
        } label:{
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color.ambientColor)
                .overlay(
                    LottieView(fileName: "LottieMap", loopMode: .repeat(3))
                        .scaleEffect(1.2)
                        .rotation3DEffect(.degrees(isAppear ? 0:-20), axis: (1,0,0))
                        .animation(.easeIn(duration: 0.3), value: isAppear)
                        .padding(.bottom,20)
                ).overlay(
                    Text("주변 정보 보기").font(Font.callout.weight(.bold))
                        .foregroundColor(.black).padding(.bottom,5)
                    ,alignment: .bottom
                )
        }.onAppear(){
            isAppear.toggle()
        }
    }
}

struct MainMapBtn_Previews: PreviewProvider {
    static var previews: some View {
        MainMapBtn(linkAction: {
            print("Hello world!!")
        })
            .frame(width: 200,height: 200)
    }
}
