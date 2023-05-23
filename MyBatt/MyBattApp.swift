//
//  MyBattApp.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/03/27.
//

import SwiftUI

@main
struct MyBattApp: App {
    @StateObject var appManager = AppManager()
    var body: some Scene {
        WindowGroup {
            if appManager.isLoginActive{
                ContentView()
                    .environmentObject(appManager)
                    .onAppear(){
                        Appearances.navigationBarWhite()
                        Appearances.tabBarClear()
                    }
            }else{
                OnboardingView().environmentObject(appManager)
            }
        }
    }

}
