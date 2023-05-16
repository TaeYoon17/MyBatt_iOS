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
                Button{
                    takenPhotoPage = false
                }label:{
                    Label {
                        Text("다시 촬영하기").fontWeight(.bold)
                    } icon: {
                        Image(systemName: "arrowshape.turn.up.backward")
                    }.font(.headline)
                        .frame(width:
                                screenWidth/3
                        )
                        .padding()
                        .foregroundColor(.red)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 5)
                                .foregroundColor(.red)
                        )
                }
                Spacer()
                Button{
                    takenPhotoPage = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        appManager.cameraRunning(isRun: false)
                    }
                }label:{
                    Label {
                        Text("전송하기").fontWeight(.bold)
                    } icon: {
                        Image(systemName: "paperplane")
                    }.font(.headline)
                        .frame(width:screenWidth/3)
                        .padding()
                        .foregroundColor(.accentColor)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 5)
                        )
                }
                Spacer()
            }
    }
}


struct TakenBtnView_Previews: PreviewProvider {
    static var previews: some View {
        TakenBtnView(takenPhotoPage: .constant(true)).environmentObject(AppManager())
    }
}

