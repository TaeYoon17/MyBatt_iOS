//
//  SearchNavigationView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/21.
//

import SwiftUI
import UIKit
struct SearchNavigationView<Content>: View where Content:View  {
    // Search Text...
    @Binding var searchQuery:String
    @ViewBuilder let content: Content
    
    // Offsets... 네비게이션 높이 설정을 위한 Offset
    @State private var offset: CGFloat = 0
    // Start Offsets... 스크롤 뷰 영역이 맨 처음 놓였을 때, 기기 상단에서 얼마나 떨어져 있는지 캐치하기 위한 변수
    @State private var startOffset: CGFloat = 0
    
    // to move title to center were getting the title Width...
    @State var titleOffset: CGFloat = 0
    @State var titleBarHeight: CGFloat = 0
    
    
    var body: some View {
        ZStack(alignment:.top)
        {
            VStack{
                HStack{
                    Text("검색")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }.padding()
                // Search Bar...
                VStack(spacing:0){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18,weight: .semibold))
                        TextField("Search", text: $searchQuery)
                    }
                    .padding(.vertical,5)
                    .padding(.horizontal,10)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    HStack{
                        Text("최근 검색 기록").font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Rectangle().foregroundColor(.gray.opacity(0.6))
                            .frame(height: 1)
                    }.padding()
                }
            }
            .offset(y: offset > 0 ? (offset <= 75 ? -offset : -75):0)
            .zIndex(1)
            // zIndex에서 준 배경 크기를 padding bottom을 이용해서 줄인다.
            .padding(.bottom,getOffset().height)
            .background(Color.white)// 여기 색상 채워야 함
            .overlay(GeometryReader{ proxy -> Color in
                guard titleBarHeight == 0 else {return Color.clear}
                DispatchQueue.main.async {
                    guard titleBarHeight == 0 else {return }
                    let height = proxy.frame(in: .global).maxY
                    titleBarHeight = height
                }
                return Color.clear
            }
            )
            ScrollView(.vertical,showsIndicators: false)
            {
                content
                .padding(.top,titleBarHeight -
                          // 노치 크기 - 네비게이션바 크기
                         UIScreen.topSafeArea - 44
                )
                .overlay(
                    GeometryReader{proxy -> Color in
                        DispatchQueue.main.async {
                            let minY = proxy.frame(in: .global).minY
                            // 초기 offset값을 0으로 만들기 위함
                            if startOffset == 0{
                                startOffset = minY
                            }
                            offset = startOffset - minY
                        }
                        return Color.clear
                    },alignment: .top)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("검색")
                    .fontWeight(.semibold)
                    .opacity((-75+Double(offset))/75)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
    func getNabTitleOffset()->CGFloat{
        let logic = offset < 0 ? 0 : offset > 75 ? 75 : offset
        return 100*(1-logic/75)
    }
    func getOffset()->CGSize{
        var size: CGSize = .zero
        size.width = offset > 0 ? (offset * 1.5) : 0
        size.height = offset > 0 ? (offset <= 75 ? CGFloat(-offset) : -75) : 0
        return size
    }
}

struct SearchNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchNavigationView(searchQuery: .constant("hello world")){
            LazyVStack(spacing:15) {
                ForEach(0...100,id:\.self){idx in
                    Text("\(idx) 입니다.")
                }
                .padding(.top,10)
            }
        }
    }
}
