//
//  TakenPhotoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/03.
//

import SwiftUI
import Foundation
struct TakenPhotoView: View {
    @EnvironmentObject var vm: CameraModel
    @Binding var image: Image?
    var body: some View {
        ZStack{
            GeometryReader{ proxy in
                if let image = image{
                    image
                        .resizable().scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.width)
                        .clipped()
                }
            }
            Button{

            }label:{
                Text("save!!")
            }
        }
    }
}

struct TakenPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakenPhotoView(image: .constant(Image(systemName: "xmark")))
    }
}
