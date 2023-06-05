//
//  ExpertMailView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import SwiftUI

struct ExpertMailView: View {
    @State private var message = ""
    @State private var title = ""
    @State private var isSelected = false
    @State private var diagnosisResponse:DiagnosisResponse? = nil
    
    @Environment(\.dismiss) private var dismiss
    init(diagnosisResponse: DiagnosisResponse? = nil){
        self.diagnosisResponse = diagnosisResponse
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 8){
                HStack{
                    Text(title == "" ? "새로운 메시지" : title)
                    Spacer()
                    Button{
                        print("보내기 버튼 클릭")
                        self.dismiss()
                    }label:{
                        Image(systemName: "arrow.up.circle")
                            .imageScale(.large)
                            
                    }
                    .tint(.blue)
                    .disabled(checkSendDisable())
                }.font(.system(size: 36,weight: .semibold))
                    .frame(height: 40)
                    .padding(.bottom,8)
                
                VStack(spacing:0){
                    Divider().frame(height: 1).background(Color.lightGray)
                    HStack(spacing: 4){
                        Text("제목: ").foregroundColor(.accentColor)
                            .font(.headline)
                        TextField("질병, 작물 이름을 넣어주세요.", text: $title)
                            .frame(height: 44)
                            .foregroundColor(.black)
                    }
                    .frame(height: 44)
                    Divider().frame(height: 1).background(Color.lightGray)
                    if diagnosisResponse == nil {
                        self.itemSelectView.padding(.vertical,8)
                    }else{
                        self.demoItem.padding(.vertical,8)
                    }
                    Divider().frame(height: 1).background(Color.lightGray)
                }
                
                GeometryReader{ proxy in
                    ScrollView{
                        ZStack(alignment:.center){
                            TextEditor(text: $message).frame(minHeight: proxy.size.height,maxHeight: proxy.size.height)
                            if message.isEmpty{
                                Text("요청 메시지를 적으세요")
                            }
                        }
                        .background(.white)
                        .cornerRadius(8)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Text("취소")
                    }
                }
            }
        }
    }
    func checkSendDisable()->Bool{
        true
    }
}

//MARK: -- 데모 아이템
extension ExpertMailView{
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
                .padding(.top,12)
                HStack{
                    Text("병해:").font(.headline)
                    Text("잎 곰팡이병 (52%)").font(.subheadline)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(height: 100)
    }
}
//MARK: -- 작물 선택 버튼
extension ExpertMailView{
    var itemSelectView: some View{
        Button{
        }label:{
            Spacer()
            HStack(spacing: 16){
                Image(systemName: "questionmark.circle").resizable().scaledToFit()
                Text("진단 요청할 작물을 선택하세요")
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            }
                .padding()
                .foregroundColor(Color.accentColor)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth:8)
                        .foregroundColor(Color.accentColor)
                )
            .frame(height: 100)
    }
}

struct ExpertMailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMailView()
        }
    }
}
