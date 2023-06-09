//
//  PesticideDetailView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI
fileprivate struct PsisLabel:Identifiable{
    var id = UUID()
    let title:String
    let text: String
    init(_ title: String,_ text:String){
        self.title = title
        self.text = text
    }
}
struct PesticideDetailView: View {
    @Binding var isShow: Bool
    let psisInfo: PsisInfo?
    fileprivate var items:[PsisLabel]{
        var items:  [PsisLabel] = []
        if let item = psisInfo {
            items = [.init("작물명",item.cropName ?? ""),
                     .init("적용병해충",item.diseaseWeedName ?? ""),
                     .init("상표명", item.pestiBrandName ?? ""),
                     .init("법인명", item.compName ?? ""),
                     .init("용도", item.useName ?? ""),
                     .init("농약명",item.pestiKorName ?? ""),
                     .init("영어명", item.engName ?? ""),
                     .init("희석배수(10a당 사용량)",item.dilutUnit ?? ""),
                     .init("안전사용기준(수확 ~일 전)",item.useSuittime ?? ""),
                     .init("안전사용기준(~회 이내)",item.useNum ?? ""),
                     .init("사용적기",item.pestiUse ?? "")
            ]
        }
        return items
    }
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators:false){
                LazyVStack(spacing:8){
                    ForEach(items) { item in
                        VStack(spacing:0){
                            HStack(spacing:24){
                                Text("\(item.title) : ").font(.headline)
                                    .bold()
                                Spacer()
                                Text("\(item.text)")
                                    .font(.system(size: 16).weight(.medium))
                            }
                            .padding(.horizontal)
//                            if item.title != items.last.title{
//                                Divider().frame(height:1)
//                            }
                        }
                    }
                }
            }.padding(.vertical)
                .navigationTitle("농약 상세 정보")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            self.isShow = false
                        }label:{
                            Image(systemName: "xmark").foregroundColor(.black)
                        }
                    }
                }
        }
    }
}

//struct PesticideDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PesticideDetailView(isShow: .constant(true), item: .init)
//    }
//}
