//
//  NavTrailingBtn.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct NavTrailingBtn: View {
    let btnAction: ()->Void
    let imgName: String
    let labelName: String
    let textColor: Color
    let bgColor : Color
    var body: some View {
        Button{
            btnAction()
        }label: {
            HStack(spacing:4){
                Image(systemName: imgName)
                    .imageScale(.small)
                Text(labelName)
                    .font(.system(size:16).weight(.semibold))
            }
            .foregroundColor(textColor)
            Spacer()
        }
        .padding(.all,2)
        .background(bgColor)
        .cornerRadius(8)
    }
}

struct NavTrailingBtn_Previews: PreviewProvider {
    static var previews: some View {
        NavTrailingBtn(btnAction: {
            print("hello world")
        }, imgName: "xmark", labelName: "xmark", textColor: .blue, bgColor: .ambientColor)
    }
}
