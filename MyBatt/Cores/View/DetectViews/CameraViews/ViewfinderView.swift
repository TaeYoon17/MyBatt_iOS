//
//  ViewfinderView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/22.
//

import SwiftUI

struct ViewfinderView: View {
    @EnvironmentObject var cameraModel: CameraViewModel
    var body: some View {
        GeometryReader{ proxy in
            if let image = cameraModel.viewFinderImage
            {
                image
                    .resizable()
                    .scaledToFit()
//                    .clipped()
                    .gesture(MagnificationGesture().onChanged({ val in
                        cameraModel.zoom(factor: val)
                    }).onEnded({ _ in
                        cameraModel.zoomInitialize()
                    })
                    )
                    .offset(y:proxy.size.height*0.4-proxy.size.width*0.5)
            }
        }
    }
}

//struct ViewfinderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewfinderView(image: .constant(Image(systemName: "pencil")))
//    }
//}
