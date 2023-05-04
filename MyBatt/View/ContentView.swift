//
//  ContentView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/03/27.
//

import SwiftUI

enum BottomTab{
    case main, list, search, myPage
}

struct ContentView: View {
    @State var isCameraActive: Bool = false
    @State var currentTab : BottomTab = .main
    @State var hideView: Bool = false
    @EnvironmentObject var appManager:AppManager
    @State var naviStackIdx: Int = -1
    var body: some View {
        ZStack(alignment: .bottom){
            tabView.zIndex(0)
            if !appManager.isTabbarHidden{
                bottomTabs.zIndex(1)
            }
        }
    }
}

extension ContentView{
    var tabView: some View{
        TabView(selection: $currentTab) {
            MainView(isCameraActive: $isCameraActive
//                     ,naviStackIdx: $naviStackIdx
            )
                .tag(BottomTab.main)
        }
    }
    var bottomTabs: some View{
        HStack(alignment: .center){
            Spacer()
            Button {
                self.currentTab = .main
                appManager.goRootView()
            } label: {
                VStack(spacing:5){
                    Image(systemName: "house.fill")
                        .foregroundColor(.accentColor)
                        .imageScale(.large)
                    Text("홈").font(.footnote)
                }.scaleEffect(currentTab == .main ? 1 : 0.8)
                    .opacity(currentTab == .main ? 1 : 0.5)
            }.foregroundColor(.black)
                .offset(x:-20)
            Spacer()
            Spacer()
            Button {
                self.currentTab = .main
                appManager.goRootView()
            } label: {
                VStack(spacing:5){
                    Image(systemName: "person.fill")
                        .foregroundColor(Color.accentColor)
                        .imageScale(.large)
                    Text("내 정보").font(.footnote)
                }.scaleEffect(currentTab == .main ? 1 : 0.8)
                    .opacity(currentTab == .main ? 1 : 0.5)
            }.foregroundColor(.black)
            .offset(x:20)
            Spacer()
        }
        .frame(minHeight: 60)
        .background(RoundedRectangle(cornerRadius: 10)
            .foregroundColor(
                Color.lightGray
            )
        )
            .clipped()
            .edgesIgnoringSafeArea(.bottom)
            .padding(.horizontal,UIDevice.current.hasNotch ? 30 : 0)
            .overlay(cameraBtn.offset(y:-25),alignment: .center)
                
    }
    
    var cameraBtn: some View{
        Button{
            print("카메라 버튼 idx \(appManager.stackIdx)")
            appManager.goRootView()
            appManager.cameraRunning(isRun: true)
        print("작물 촬영 실행")
    }label:{
        VStack(spacing:5){
            Circle().frame(width:80,height:80).foregroundColor(Color.ambientColor)
            .overlay(
                Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 40,height: 30)
                .foregroundColor(.accentColor)
                     ,alignment: .center)
            .overlay(Circle().stroke(lineWidth: 2).foregroundColor(.black)
            )
        Text("작물 촬영하기").font(.footnote)
                .foregroundColor(.black)
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
