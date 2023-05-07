//
//  GroupBoxView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/19.
//

import Foundation
import SwiftUI
struct GroupBoxBackGround: GroupBoxStyle {
    let color:Color
    func makeBody(configuration: Configuration) -> some View {
        VStack{
            configuration.label
                .padding(.top)
                .padding(.horizontal)
            configuration.content
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom)
//                .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
        }.background(RoundedRectangle(cornerRadius: 8).fill(color))
    }
}
