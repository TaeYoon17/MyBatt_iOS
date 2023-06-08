//
//  SearchItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct SearchItemView: View {
    let imageURL:String?
    let cropName: String
    let sickName: String
    let sickEng: String
    var body: some View {
        HStack(spacing: 24){
            Rectangle().fill(.ultraThinMaterial).frame(width: 80,height: 80)
                .overlay(alignment:.center) {
                    AsyncImage(url: URL(string: imageURL ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(1,contentMode: .fill)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "logo_demo")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
                    }
                    
                }
            Rectangle()
                .fill(Color.clear)
                .frame(width: 60,height: 80)
                .overlay(alignment:.leading) {
                    Text(cropName)
                        .font(.headline.weight(.semibold))
                        .bold()
                        .foregroundColor(Color.black)
                }
            VStack(alignment: .leading, spacing: 4){
                Text(sickName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.5)
                Text(sickEng)
                    .font(.footnote)
                    .foregroundColor(Color.black)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.5)
            }
            Spacer()
        }
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchItemView(imageURL: "http://ncpms.rda.go.kr/npmsAPI/thumbnailViewer2.mo?uploadSpec=npms&uploadSubDirectory=/photo/sickns/&imageFileName=f3d4f149581573cc534eb355bf5c90d36e391fbdaacbb84c75f545d063c4eb44c2f940f40a2905f96a63b151e89d52c724a8419889bf650128bb2b4acfc38c2e", cropName: "토마토", sickName: "줄기무름병", sickEng: "Bacterial stem rot")
    }
}
