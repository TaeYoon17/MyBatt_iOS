//
//  TakenPhotoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/03.
//

import SwiftUI

struct TakenPhotoView: View {
    @Binding var image: Image?
    var body: some View {
        GeometryReader{ proxy in
            if let image = image{
                image
                    .resizable()
//                    .frame(width: proxy.size.width, height: proxy.size.width)
                    .scaledToFill()
                    
            }
            
        }
    }
}

struct TakenPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakenPhotoView(image: .constant(Image(systemName: "xmark")))
    }
}
