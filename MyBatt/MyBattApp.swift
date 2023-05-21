//
//  MyBattApp.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/03/27.
//

import SwiftUI

@main
struct MyBattApp: App {
    @State private var isTrue = false
    var body: some Scene {
        WindowGroup {
            if isTrue{
                ContentView()
                    .environmentObject(AppManager())
                    .onAppear(){
                        Appearances.navigationBarWhite()
                        Appearances.tabBarClear()
                    }
            }else{
                LogInView()
            }
        }
    }

}
