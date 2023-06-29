//
//  MemoListView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/28.
//

import SwiftUI

struct MemoListView: View {
    var body: some View {
        LazyVStack{
            ForEach(0...40,id:\.self) { idx in
                MemoListItemView()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
    }
}


struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
    }
}
