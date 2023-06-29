//
//  MemoListItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import SwiftUI

struct MemoListItemView: View{
    @State private var moveX:CGFloat = 0
    @State private var isMove: Bool = false
    @State private var isTapped: Bool = false
    var body: some View{
        ZStack{
            HStack{
                Color.accentColor.frame(width: 100)
                    .overlay(alignment:.leading) {
                        Button{
                            print("수정하기 버튼 클릭")
                        }label: {
                            VStack(spacing: 4){
                                Image(systemName: "note.text")
                                    .imageScale(.medium)
                                Text("수정하기")
                                    .font(.footnote).bold()
                            }
                        }.foregroundColor(.white)
                            .padding(.leading)
                    }
                Spacer()
                Color.red.frame(width: 100)
                    .overlay(alignment:.trailing) {
                        Button{
                            print("수정하기 버튼 클릭")
                        }label: {
                            VStack(spacing: 4){
                                Image(systemName: "trash")
                                    .imageScale(.medium)
                                Text("삭제하기")
                                    .font(.footnote).bold()
                            }
                        }.foregroundColor(.white)
                            .padding(.trailing)
                    }
            }
            
            VStack(alignment:.leading,spacing:8){
                //                HStack{
                Text("이게 왜 안되는지 모르겠다 진짜로!!")
                    .font(.callout.weight(.medium))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal,4)
                HStack(spacing:4){
                    Spacer()
                    dateView(dateType: "작성일", dateStr: "20년 12월 18일")
                    Divider().frame(width: 1,height: 12).background(Color.accentColor)
                    dateView(dateType: "최근 수정일", dateStr: "21년 5월 21일")
                }.padding(.trailing,4)
            }
            .opacity(isTapped ? 0.1 : 1)
//            .animation(.easeIn, value: isTapped)
            .padding(.all,8)
            .background(Color.white)
                .contentShape(Rectangle())
                .offset(x: moveX)
                .animation(.default, value: moveX)
                .onTapGesture {
                    if isMove{
                        self.moveX = 0
                        isMove = false
                        return
                    }else{
                        isTapped.toggle()
                        if isTapped == true{
                            withAnimation(.easeOut(duration: 1)){
                                isTapped.toggle()
                            }
                        }
                    }
                }
                .gesture(DragGesture().onChanged({ val in
                    let tempX = val.location.x - val.startLocation.x
                    moveX = tempX < -100 ? -100 : tempX > 100 ? 100 : tempX
                }).onEnded({ val in
                    let isMarkerOn = abs(val.location.x - val.startLocation.x) > 85
                    if val.location.x > val.startLocation.x{// 오른쪽으로 이동함
                        if isMove{
                            moveX = 0
                            isMove = false
                        }else{
                            moveX = isMarkerOn ? 80 : 0
                            isMove = isMarkerOn
                        }
                    }else{// 왼쪽으로 이동함
                        if isMove{
                            moveX = 0
                            isMove = false
                        }else{
                            moveX = isMarkerOn ? -80 : 0
                            isMove = isMarkerOn
                        }
                    }
                })
                )
                .clipped()
        }
        .cornerRadius(8)
    }
    
    @MainActor
    func dateView(dateType:String,dateStr:String)->some View{
        HStack(spacing:0){
            Text("\(dateType): ").font(.caption)
                Text(dateStr).font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
        }
    }
}


struct MemoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListItemView()
    }
}
