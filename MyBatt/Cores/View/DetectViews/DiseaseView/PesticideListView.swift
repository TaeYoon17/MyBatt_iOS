//
//  Home.swift
//  ResizableAppBarDemo
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct PesticideListView: View {
    @StateObject private var vm: PsisInfoVM
    let topInset: CGFloat
    @Namespace var animation
    @State private var isShow = true
    @State private var present = false
    @State private var item: PsisInfo? = nil
    let cropName: String
    let sickName: String
    init(topInset: CGFloat,cropName: String,sickName: String){
        self.topInset = topInset
        self.cropName = cropName
        self.sickName = sickName
        self._vm = StateObject(wrappedValue: PsisInfoVM(cropName: cropName, sickNameKor: sickName))
    }
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
                        ForEach(self.vm.psisList){ item in
                            Button{
                                self.item = item
                                self.present = true
                            }label:{
                                PesticideListItem(pestiKorName: item.pestiKorName,
                                                  pestiBrandName: item.pestiBrandName,
                                                  compName: item.compName)
                                .frame(height: 60)
                                .background(.gray.opacity(0.07))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .padding(.horizontal)
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
            PesticideDetailView(isShow: $present,psisInfo: self.item)
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
                    Text("\(vm.maxCnt)개 ")
                        .font(.title)
                        .fontWeight(.bold)
                    ScrollView(.horizontal){
                        Text("\(cropName) \(sickName)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }.foregroundColor(.accentColor)
                    .padding(.horizontal)
            }
            
                GeometryReader{ proxy in
                    HStack (alignment:.center, spacing: 16){
                        Rectangle().fill(.clear).overlay(alignment:.leading) {
                            Text("농약명")
                        }.frame(width: proxy.size.width / 4)
                        Rectangle().fill(.clear).overlay(alignment:.leading){
                            Text("상표명")
                        }.frame(width: proxy.size.width / 5)
                        Text("회사명")
                        Spacer()
                    }
                    
                }.frame(height: 24)
            
            .font(.headline.weight(.semibold))
            .padding(.horizontal)
            .padding(.vertical,8)
            .padding(.horizontal)
            .background(.gray.opacity(0.2))
            .padding(.top)
        }
    }
}
//struct PesticideList_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            DiseaseInfoView(sickKey: "D00001545")
//        }
//    }
//}

