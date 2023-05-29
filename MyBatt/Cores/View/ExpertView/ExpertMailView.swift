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
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 12){
                HStack{
                    Text(title == "" ? "새로운 메시지" : title)
                    Spacer()
                    Button{
                        print("보내기 버튼 클릭")
                        self.dismiss()
                    }label:{
                        Image(systemName: "arrow.up.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }.font(.system(size: 36,weight: .semibold))
                    .frame(height: 40)
                    .padding(.bottom)
                VStack(spacing:4){
                    Divider().frame(height: 1).background(Color.lightGray)
                    HStack(spacing: 4){
                        Text("제목: ").foregroundColor(.accentColor)
                            .font(.headline)
                        TextField("질병, 작물 이름을 넣어주세요.", text: $title)
                            .frame(height: 50)
                            .foregroundColor(.black)
                        
                    }
                    .frame(height: 50)
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
}

struct ExpertMailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMailView()
        }
    }
}
