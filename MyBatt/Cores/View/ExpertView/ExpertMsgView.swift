//
//  ExpertMsgView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/06.
//

import SwiftUI

struct ExpertMsgView: View {
    let width = UIScreen.main.bounds.width
    @Environment(\.dismiss) private var dismiss
    @State private var myRequest: String? = "이게 왜 안되는 거냐고오~~"
    @State private var expertResult: String? = nil
    var body: some View {
        NavigationView {
            VStack(spacing:0){
                HStack(alignment:.center, spacing:4){
                        Text("토마토 버거씨병 같은데 아니래용")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.black)
                            .padding(.bottom,4)
                    Spacer()
                }.padding(.bottom)
                ScrollView {
                    demoItem
                    divider
                    if let myRequest = myRequest, myRequest != ""{
                        myQuestion(myRequest: myRequest)
                        divider
                    }
                    expertResultView
                    Spacer()
                }
            }.padding()
                .navigationTitle("문의 답변")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            self.dismiss()
                        }label: {
                            Text("완료")
                        }
                    }
                }
        }
    }
    @ViewBuilder
    func makeTextBubble(_ message: String,fgColor: Color,bgColor: Color,isFlip: Bool)->some View{
        Text(message)
            .foregroundColor(fgColor)
            .font(.body.weight(.medium))
            .padding()
            .background(bgColor)
            .cornerRadius(12)
            .overlay(alignment:isFlip ? .topLeading : .topTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(isFlip ? 135 : -135))
                    .offset(x: isFlip ? -10 : 10,y:-10)
                    .foregroundColor(bgColor)
            }
            .padding(.top,8)
            .padding(.horizontal)
    }
    var demoItem: some View{
        HStack(spacing: 16){
            Image("logo_demo")
                .resizable()
                .scaledToFit()
                .background(Color.ambientColor)
                .cornerRadius(8)
            VStack(alignment: .leading,spacing: 4){
                HStack{
                    Text("토마토").font(.headline)
                    Text("2023.06.04 20:24").font(.subheadline)
                    Spacer()
                }
                HStack(alignment:.top){
                    Text("병해:").font(.headline)
                    Text("고추 마일드 모틀바이러스 (52%)").font(.subheadline)
                    Spacer()
                }
                Spacer()
            }.overlay(alignment:.topTrailing){
                Image(systemName: "chevron.right")
                    .padding(.top,8)
            }
        }
        .padding(.vertical,12)
        .background(Color.white)
        .frame(height: 120)
    }
}

extension ExpertMsgView{
    //MARK: -- Divider 설정
    var divider: some View{
        Divider().frame(height: 2)
            .background(Color.lightGray)
            .padding(.vertical,4)
    }
    func myQuestion(myRequest: String)->some View{
        VStack(alignment: .leading,spacing:8){
            Text("내 질문").font(.title2).bold()
            HStack{
                HStack{
                    makeTextBubble(myRequest,fgColor: .black, bgColor: .lightGray, isFlip: true)
                    Spacer()
                }
                .frame(minWidth: 0,maxWidth: width * 0.8)
                Spacer()
            }
        }
    }
    var expertResultView: some View{
        VStack(alignment: .trailing,spacing:8){
            Text("전문가 답변").font(.title2).bold()
            HStack{
                Spacer()
                HStack{
                    Spacer()
                    if let result = expertResult,result != ""{
                        makeTextBubble("이건 너가 잘 못 찍어서 잘 모르겠는뒈~",fgColor: .black ,bgColor: .ambientColor, isFlip: false)
                    }else{
                        makeTextBubble("아직 답변이 오지 않았어요",fgColor: .white ,bgColor: .red, isFlip: false)
                    }
                }
                .frame(minWidth: 0,maxWidth: width * 0.8)
            }
        }
    }
}

struct ExpertMsgView_Previews: PreviewProvider {
    static var previews: some View {
        
            ExpertMsgView()
        
    }
}
