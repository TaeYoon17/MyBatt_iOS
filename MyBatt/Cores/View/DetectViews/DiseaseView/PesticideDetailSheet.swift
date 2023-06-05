//
//  PesticideDetailView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct PesticideDetailView: View {
    @Binding var isShow: Bool
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators:false){
                ForEach(0...10,id:\.self) { _ in
                    VStack(spacing:4){
                        HStack(spacing:24){
                            Text("작물명 : ").font(.headline)
                                .bold()
                            Spacer()
                            Text(" 토마토")
                                .font(.system(size: 16).weight(.medium))
                        }.padding(.horizontal)
                        Divider().frame(height: 1)
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

struct PesticideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PesticideDetailView(isShow: .constant(true))
    }
}
