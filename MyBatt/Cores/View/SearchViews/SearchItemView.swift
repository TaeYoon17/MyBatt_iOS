//
//  SearchItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct SearchItemView: View {
    var body: some View {
        HStack(spacing: 24){
            Rectangle().fill(.ultraThinMaterial).frame(width: 60,height: 60)
                .overlay(alignment:.center) {
                    Image("logo_demo")
                        .resizable()
                        .scaledToFit()
                }
            Rectangle()
                .fill(.clear)
                .frame(width: 72,height: 60)
                .overlay(alignment:.leading) {
                    Text("파프리카")
                        .font(.headline.weight(.semibold))
                        .bold()
                }
            VStack(alignment: .leading, spacing: 8){
                Text("시들음병")
                    .font(.subheadline.weight(.semibold))
                Text("Fusarlum wilt")
                    .font(.footnote)
            }
            Spacer()
        }
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchItemView()
    }
}
