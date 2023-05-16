//
//  CornerRoundedView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/20.
//

import Foundation
import SwiftUI
struct RoundedTopRectangle: Shape {
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))// 우 하단

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))//좌 하단
//        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY+radius))// 좌 상단
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX-radius, y: rect.minY))// 우 하단
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}
