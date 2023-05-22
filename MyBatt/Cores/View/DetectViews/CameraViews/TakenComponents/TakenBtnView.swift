//
//  TakenBtnView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import SwiftUI

struct TakenBtnView: View {
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var appManager: AppManager
    @Binding var takenPhotoPage: Bool
    var body: some View {
            HStack{
                Spacer()
                ImageAppeaerBtnView(btnAction: {
                    takenPhotoPage = false
                }, labelText: "다시 촬영하기", iconName: "arrowshape.turn.up.backward",bgColor: .red)
                Spacer()
                ImageAppeaerBtnView(btnAction: {
                    takenPhotoPage = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        appManager.cameraRunning(isRun: false)
                    }
                }, labelText: "전송하기", iconName:
                                        "paperplane", bgColor: .accentColor)
                Spacer()
            }
    }
}


struct TakenBtnView_Previews: PreviewProvider {
    static var previews: some View {
        TakenBtnView(takenPhotoPage: .constant(true)).environmentObject(AppManager())
    }
}

