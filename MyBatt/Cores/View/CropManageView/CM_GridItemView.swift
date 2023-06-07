//
//  CM_GridItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/04.
//

import SwiftUI

struct CM_GridItemView: View {
    @Binding var isEditting: Bool
    let memo: String
    let cnt: Int
    let color: Color
    let name: String
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.lightGray)
            .aspectRatio(1,contentMode: .fit)
            .overlay(alignment:.top){
                GroupBox {
                    VStack(alignment:.leading){
                        Divider()
                        Text(memo)
                            .font(Font.callout)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } label: {
                    HStack{
                        Text("\(name) (\(cnt))").font(.subheadline.weight(.semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .imageScale(.small)
                    }
                }.groupBoxStyle(GroupBoxBackGround(color:color))
                    .foregroundColor(.black)
                
            }
            .overlay(alignment:.topLeading) {
                if isEditting{
                    Button {
                        print("삭제 아이콘 클릭")
                    } label: {
                        itemRemoveView
                    }
                    .offset(x:-8,y:-4)
                }
            }
    }
}

extension CM_GridItemView{
    @ViewBuilder
    var itemRemoveView: some View{
        Image(systemName: "minus.circle")
            .resizable()
            .aspectRatio(1,contentMode: .fit)
            .frame(width: 24)
            .foregroundColor(.red)
            .background(Circle().fill(.thickMaterial))
    }
}
struct CM_GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        CM_MainView().environmentObject(AppManager())
    }
}
