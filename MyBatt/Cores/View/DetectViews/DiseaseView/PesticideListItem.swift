//
//  PesticideListItem.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct PesticideListItem: View {
    let pestiKorName: String
    let pestiBrandName: String
    let compName: String
    var body: some View {
        GeometryReader{ proxy in
            HStack (alignment:.center, spacing: 16){
                Rectangle().fill(.clear).overlay(alignment:.leading) {
                    Text(pestiKorName)
                        .font(.headline)
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                }.frame(width: proxy.size.width / 4)
                Rectangle().fill(.clear).overlay(alignment:.leading){
                    Text(pestiBrandName)
                        .font(.subheadline)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.leading)
                }.frame(width: proxy.size.width / 5)
                Text(compName)
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .frame(height: proxy.size.height)
            .padding(.horizontal)
        }
    }
}

struct PesticideListItem_Previews: PreviewProvider {
    static var previews: some View {
        PesticideListItem(pestiKorName: "가스가마이신", pestiBrandName: "카스민", compName: "아그리젠토 (주)")
    }
}
