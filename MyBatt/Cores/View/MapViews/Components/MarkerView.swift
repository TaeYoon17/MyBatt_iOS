//
//  MarkerView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/22.
//

import SwiftUI

struct MarkerView: View {
    let cropType: DiagCropType
    var body: some View {
        VStack(spacing:0){
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 28,height: 28)
                .font(.headline)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.accentColor)
                .clipShape(Circle())
                .overlay(alignment:.center) {
                    Text(DiagCrop.iconTable[cropType]!).font(.footnote)
                }
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.accentColor)
                .frame(width: 8,height: 8)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom,40)
        }
    }
    
}

struct MarkerView_Previews: PreviewProvider {
    static var previews: some View {
        MarkerView(cropType: .Lettuce)
    }
}
