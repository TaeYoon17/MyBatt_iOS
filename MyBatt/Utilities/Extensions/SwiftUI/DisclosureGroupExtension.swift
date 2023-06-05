//
//  DisclosureGroupExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

extension DisclosureGroup{
//    func bgColor(_ color: Color,paddingSize: CGFloat = 8)->some View{
//        self.groupBoxStyle(CustomGroupBoxStyle(color: color,paddingSize: paddingSize))
//    }
}
 struct CustomDisclosureGroupStyle: DisclosureGroupStyle{
    let color: Color
    let paddingSize: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(.title2)
                Spacer()
            }.background(Color.lightGray)
            configuration.content
        }
        .padding(.all,paddingSize)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(color)) // Set your color here!!
    }
}
