//
//  MemoListItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import SwiftUI

struct MemoListItemView: View{
    @Binding var model: MemoModel
    @Binding var isEditing: Int?
    @Binding var isDelete: Int?
    @Binding var isShowMemo: Bool
    @State private var moveX:CGFloat = 0
    @State private var isMove: Bool = false
    @State private var isTapped: Bool = false
    @State private var isShow: Bool = false
    var body: some View{
        ZStack{
            if isShow{
                HStack{
                    Color.accentColor.frame(width: 100)
                        .overlay(alignment:.leading) {
                            Button{
                                isEditing = model.memoId
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
                                isDelete = model.memoId
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
            }
            
            VStack(alignment:.leading,spacing:8){
                //                HStack{
//                "이게 왜 안되는지 모르겠다 진짜로!!"
                Text(model.contents)
                    .font(.callout.weight(.medium))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal,4)
                HStack(spacing:4){
                    Spacer()
                    dateView(dateType: "작성일", dateStr: Date.changeDateFormat(dateString: model.regDt))
                    Divider().frame(width: 1,height: 12).background(Color.accentColor)
                    dateView(dateType: "최근 수정일", dateStr: Date.changeDateFormat(dateString: model.updateDt))
                }.padding(.trailing,4)
            }
            .opacity(isTapped ? 0.1 : 1)
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
                            DispatchQueue.main.async {
                                moveX = isMarkerOn ? 80 : 0
                            }
                            isMove = isMarkerOn
                        }
                    }else{// 왼쪽으로 이동함
                        if isMove{
                            moveX = 0
                            isMove = false
                        }else{
                            DispatchQueue.main.async {
                                moveX = isMarkerOn ? -80 : 0
                            }
                            isMove = isMarkerOn
                        }
                    }
                })
                )
                .clipped()
        }
        .cornerRadius(8)
        .onChange(of: isShowMemo, perform: { newValue in
            if newValue == false{
                isShow.toggle()
            }
        })
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                isShow.toggle()
            }
        }
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
        MemoListItemView(model: .constant(.init(memoId: 1, diagnosisRecord: nil, regDt: "asfd", updateDt: "asdf", contents: "asdf")), isEditing: .constant(nil),isDelete: .constant(nil), isShowMemo: .constant(true))
    }
}
