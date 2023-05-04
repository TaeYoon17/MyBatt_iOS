//
//  ViewExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/20.
//

import Foundation
import UIKit
import SwiftUI
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
struct LinkActive: ViewModifier{
    var linkViewType: MainLinkViewType
    func body(content: Content) -> some View {
        content.onTapGesture {
            print("hello")
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    func linkActive(linkViewType: MainLinkViewType) -> some View{
        ModifiedContent(content: self, modifier: LinkActive(linkViewType: linkViewType))
    }
}

struct NavigationBarColorModifier<Background>: ViewModifier where Background: View {
    
    let background: () -> Background
    
    public init(@ViewBuilder background: @escaping () -> Background) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance

        self.background = background
    }

    func body(content: Content) -> some View {
        // Color(UIColor.secondarySystemBackground)
        ZStack {
            content
            VStack {
                background()
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 0, alignment: .center)

                Spacer() // to move the navigation bar to top
            }
        }
    }
}

public extension View {
    func navigationBarBackground<Background: View>(@ViewBuilder _ background: @escaping () -> Background) -> some View {
        modifier(NavigationBarColorModifier(background: background))
    }
}
