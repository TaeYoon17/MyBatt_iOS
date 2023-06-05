//
//  Home.swift
//  ResizableAppBarDemo
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct PesticideListView: View {
    let topInset: CGFloat
    @Namespace var animation
    @State private var isShow = true
    @State private var present = false
    var body: some View {
        VStack(spacing:0){
            // App Bar...
            self.appBar
            // Content....
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0){
                    // geometry reader for getting location values...
                    self.scrollReader.frame(height:0)
                    // MARK: -- 콘텐츠 배치
                    Rectangle().fill(.white).frame(height: 12)
                    LazyVStack(spacing: 12) {
                        ForEach(1...100,id:\.self){_ in
                            Button{
                                self.present = true
                            }label:{
                                PesticideListItem().frame(height: 44)
                                    .background(.gray.opacity(0.07))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    //MARK: -- 아래 패딩
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 44)
                }
            }
            .background()
            .coordinateSpace(name: "content")
        }
        .navigationTitle("농약 정보")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $present) {
            PesticideDetailView(isShow: $present)
        }.presentationDetents([.medium])
    }
}
//MARK: -- 스크롤 감지 리더
extension PesticideListView{
    var scrollReader: some View{
        GeometryReader{ proxy -> AnyView in
            let yAxis: CGFloat = proxy.frame(in: .named("content")).minY
            print(yAxis)
            if -16 > yAxis && isShow{
                print("줄입니다.")
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.1)) {
                        isShow = false
                    }
                }
            }
            if -16 < yAxis && !isShow{
                print("늘립니다.")
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.1)) {
                        isShow = true
                    }
                }
            }
            return AnyView(
                Text("").frame(width: 0,height:0)
            )
        }
    }
}
//MARK: -- 헤더 뷰
extension PesticideListView{
    var appBar: some View{
        VStack(spacing:0){
            if isShow{
                HStack(alignment:.bottom, spacing:4){
                    Text("21개")
                        .font(.title)
                        .fontWeight(.bold)
                    ScrollView(.horizontal){
                        Text(" 버거씨병")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }.foregroundColor(.accentColor)
                .padding(.horizontal)
            }
            HStack(alignment: .center, spacing: 24){
                HStack{
                    Text("농약명")
                    Spacer()
                }
                    .frame(width: 100)
                HStack{
                    Text("상표명")
                    Spacer()
                }
                    .frame(width: 70)
                Text("회사명")
                Spacer()
            }
            .font(.headline.weight(.semibold))
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(.gray.opacity(0.2))
            .padding(.top)
        }
    }
}
struct PesticideList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiseaseInfoView()
        }
    }
}

