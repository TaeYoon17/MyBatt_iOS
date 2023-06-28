//
//  Appearances.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/22.
//

import UIKit
import SwiftUI
enum Appearances{
    static func navigationBar(material: UIBlurEffect.Style){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: material)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func navigationBar(color: UIColor){
        let appeaernce = UINavigationBarAppearance()
        appeaernce.configureWithDefaultBackground()
        appeaernce.backgroundColor = color
        appeaernce.shadowColor = color
        print(UINavigationBar.appearance())
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().standardAppearance = appeaernce
        UINavigationBar.appearance().compactAppearance = appeaernce
        UINavigationBar.appearance().scrollEdgeAppearance = appeaernce
    }
    static func navigationBarWhite(){
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func navigationBarClear(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    static func tabBarClear(){
        let transparentAppearence = UITabBarAppearance()
        transparentAppearence.backgroundColor = .clear
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
