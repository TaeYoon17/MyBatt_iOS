//
//  MyBattApp.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/03/27.
//

import SwiftUI

@main
struct MyBattApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager())
                .onAppear(){
                    Appearances.navigationBarWhite()
                    Appearances.tabBarClear()
                }
        }
    }

}
