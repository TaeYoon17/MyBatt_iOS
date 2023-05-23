//
//  BorderModifier.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/23.
//

import Foundation
import SwiftUI

struct BorderModifier: ViewModifier{
    let paddingSize: CGFloat
    let color: Color = .gray.opacity(0.3)
    let lineWidth: CGFloat = 2
    func body(content: Content) -> some View {
        content.padding(.all,paddingSize)
            .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(color)
        )
        .font(.subheadline)
    }
}

struct DiagnosisInfoViewModifier: ViewModifier{
    let paddingSize: CGFloat
    func body(content: Content) -> some View {
        content.padding(.all,paddingSize)
            .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .foregroundColor(.gray.opacity(0.3))
        )
        .font(.subheadline)
    }
}
