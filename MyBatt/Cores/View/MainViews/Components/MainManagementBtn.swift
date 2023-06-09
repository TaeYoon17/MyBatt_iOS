//
//  MainManagementBtn.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/28.
//

import SwiftUI

struct MainManagementBtn: View {
    let itemList:[(String,Int)]
    var linkAction: ()->()
    var body: some View {
        RoundedRectangle(cornerRadius: 10).foregroundColor(Color.lightGray)
            .overlay(
                GroupBox {
                    VStack{
                        Divider()
                        VStack(alignment: .leading,spacing: 5){
                            //MARK: -- 여기 작성 - 작물 관리 폴더 이름
                                                        ForEach(0...3,id:\.self){ idx in
                                                            if idx < itemList.count{
                                                                HStack{
                                                                    Text("\(itemList[idx].0 == "unclassified" ? "미분류 그룹" : itemList[idx].0)").font(.subheadline).bold()
                                                                     .lineLimit(1)
                                                                    Spacer()
                                                                    Text("(\(itemList[idx].1))").font(.footnote)
                                                                        .lineLimit(1)
                                                                }
                                                            }
                                                        }
                        }
                    }
                } label: {
                    HStack(alignment:.lastTextBaseline){
                        Text("내 작물 관리").font(.subheadline.weight(.semibold))
                        Spacer()
                        Button{
                            linkAction()
                        } label:{
                            Text("전체 보기")
                                .font(.caption2.weight(.semibold))
                                .underline()
                        }
                    }
                }.groupBoxStyle(GroupBoxBackGround(color: Color.lightGray))
                ,alignment: .top).scaledToFit()
    }
}

struct MainManagementBtn_Previews: PreviewProvider {
    static var previews: some View {
        MainManagementBtn(itemList: [("없는 작물",0)], linkAction: {
            print("Hello world")
        })
    }
}
