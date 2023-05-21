//
//  GroupBoxExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import SwiftUI
extension GroupBox{
    func bgColor(_ color: Color,paddingSize: CGFloat = 8)->some View{
        self.groupBoxStyle(CustomGroupBoxStyle(color: color,paddingSize: paddingSize))
    }
}



fileprivate struct CustomGroupBoxStyle: GroupBoxStyle{
    let color: Color
    let paddingSize: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(.headline)
                Spacer()
            }
            configuration.content
        }
        .padding(.all,paddingSize)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(color)) // Set your color here!!
    }
}
