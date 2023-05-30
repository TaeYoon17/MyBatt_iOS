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
    @StateObject var userVM = UserVM()
    var body: some Scene {
        WindowGroup {
            if userVM.isUserLoggined{
                ContentView()
                    .transition(.opacity)
                    .environmentObject(appManager)
                    .environmentObject(userVM)
                    .onAppear(){
                        print("isAlreadyLoggedIn:",userVM.isUserLoggined)
                        Appearances.navigationBarWhite()
                        Appearances.tabBarClear()
                        userVM.fetchOutbreakList()
                        
                    }
            }else{
                OnboardingView()
                    .transition(.opacity)
                    .environmentObject(userVM)
                    .environmentObject(appManager)
            }
        }
    }

}
