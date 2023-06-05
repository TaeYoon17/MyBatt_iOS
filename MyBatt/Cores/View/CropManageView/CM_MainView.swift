//
//  CM_MainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct CM_MainView: View {
    @EnvironmentObject var appManager: AppManager
    @State private var isEditting: Bool = false
    @State private var addFolderSheet: Bool = false
    @State private var goNextView = false
    var body: some View {
        ZStack{
            NavigationLink(isActive: $goNextView) {
                CM_CateListView()
            } label: {
                EmptyView()
            }
            self.categoryGridView
        }
            .navigationTitle("내 작물 관리")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(isEditting)
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){
                    if isEditting{
                        Button{
                            self.addFolderSheet = true
                        }label: {
                            Image(systemName: "folder.badge.plus")
                        }.foregroundColor(.blue)
                            .sheet(isPresented: $addFolderSheet, content: {
                                Text("addFolderSheet")
                            })
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        withAnimation{
                            self.isEditting.toggle()
                        }
                    }label: {
                        Text(isEditting ? "완료" : "편집")
                    }
                    
                }
            }
    }
    
    // 카테고리 그룹 그리드
    @ViewBuilder
    var categoryGridView: some View{
        ScrollView{
            LazyVGrid(columns: [GridItem(.flexible(),spacing: 20),GridItem(.flexible(),spacing: 20)],
                      spacing: 20,content: {                ForEach(0...10,id:\.self) { idx in
                CM_GridItemView(isEditting: $isEditting, goNextView: $goNextView)
            }
            })
            .padding()
        }
    }
}




struct CM_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CM_MainView()
        }
    }
}
