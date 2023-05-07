//
//  MapMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//

import SwiftUI

struct MapMainView: View {
    @EnvironmentObject var appManager: AppManager
    var body: some View {
            KakaoMapViewWrapper()
            .ignoresSafeArea(.all)
            .onAppear(){
                appManager.isTabbarHidden = true
            }
            .onDisappear(){
                withAnimation(.easeOut(duration: 0.2)) {
                    appManager.isTabbarHidden = false
                }
            }
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView().environmentObject(AppManager())
    }
}
