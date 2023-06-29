//
//  MemoListView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/28.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject var vm: MemoVM
    @Binding var isShowMemo :Bool
    @Binding var deleteItem: Int?
    @Binding var editingItem: Int?
    var body: some View {
        LazyVStack{
            ForEach(vm.memoList.indices,id:\.self) { idx in
                MemoListItemView(model: $vm.memoList[idx], isEditing: $editingItem,isDelete: $deleteItem,isShowMemo: $isShowMemo)
            }
            .padding(.all)
            .background(Color.lightGray)
        }
    }
}
    struct MemoListView_Previews: PreviewProvider {
        static var previews: some View {
            MemoListView(isShowMemo: .constant(true), deleteItem: .constant(nil), editingItem: .constant(nil))
        }
    }
