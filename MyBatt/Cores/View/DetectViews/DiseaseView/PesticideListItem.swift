//
//  PesticideListItem.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct PesticideListItem: View {
    var body: some View {
        GeometryReader{ proxy in
            HStack (alignment:.center, spacing: 16){
                Text("Hello, World!")
                    .multilineTextAlignment(.leading)
                    .frame(width: proxy.size.width / 4)
                Text("골든벨")
                .frame(width: proxy.size.width / 6)
                Text("(주) 동방아그로")
                Spacer()
            }
            .padding()
        }
    }
}

struct PesticideListItem_Previews: PreviewProvider {
    static var previews: some View {
        PesticideListItem()
    }
}
