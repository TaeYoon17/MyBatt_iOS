//
//  ImageAppeaerBtnView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/22.
//

import SwiftUI

struct ImageAppeaerBtnView: View {
    let screenWidth = UIScreen.main.bounds.width
//    @EnvironmentObject var appManager: AppManager
//    @Binding var takenPhotoPage: Bool
    var btnAction: (()->Void)?
    let labelText: String
    let iconName: String
    let bgColor: Color
    var body: some View {
        Button{
            if btnAction != nil{
                self.btnAction!()
            }
        }label:{
            Label {
                    Text(labelText).fontWeight(.bold)
                } icon: {
                Image(systemName: iconName)
            }.font(.headline)
                .frame(width: screenWidth/3 )
                .padding()
                .foregroundColor(bgColor)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 5)
                        .foregroundColor(bgColor)
                )
        }
    }
}

struct ImageAppeaerBtnView_Previews: PreviewProvider {
    static var previews: some View {
        ImageAppeaerBtnView(btnAction: {
            print("Hello world")
        }, labelText: "다시 촬영하기", iconName: "arrowshape.turn.up.backward",bgColor: .red)
    }
}
