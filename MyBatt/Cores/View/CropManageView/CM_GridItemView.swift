//
//  CM_GridItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/04.
//

import SwiftUI

struct CM_GridItemView: View {
    @Binding var isEditting: Bool
    @Binding var goNextView: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 10 )
            .fill(Color.lightGray)
            .aspectRatio(1,contentMode: .fit)
            .overlay(alignment:.top){
                Button{
                    goNextView = true
                }label:{
                    GroupBox {
                        VStack(alignment:.leading){
                            Divider()
                            Text("병해 진단 후 카테고리가 설정되지 않은 작물들입니다.")
                                .font(Font.callout)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    } label: {
                        HStack{
                            Text("미분류 그룹 (1)").font(.subheadline.weight(.semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .imageScale(.small)
                        }
                    }.groupBoxStyle(GroupBoxBackGround(color:Color.lightAmbientColor))
                        .foregroundColor(.black)
                }
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
