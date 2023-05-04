//
//  Appearances.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/22.
//

import UIKit
final class Appearances{
    static func navigationBarWhite(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func navigationBarClear(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func tabBarClear(){
        let transparentAppearence = UITabBarAppearance()
        transparentAppearence.backgroundColor = .white
        transparentAppearence.shadowColor = .clear
        transparentAppearence.shadowImage = .none
        UITabBar.appearance().standardAppearance = transparentAppearence
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().standardAppearance = transparentAppearence
    }
    static func tabBarWhite(){
        let transparentAppearence = UITabBarAppearance()
        transparentAppearence.backgroundColor = .white
        transparentAppearence.shadowColor = .clear
        transparentAppearence.shadowImage = .none
        UITabBar.appearance().standardAppearance = transparentAppearence
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().standardAppearance = transparentAppearence
    }
}
