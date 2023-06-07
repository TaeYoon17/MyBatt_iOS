//
//  CM_MainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct CM_MainView: View {
    @EnvironmentObject var appManager: AppManager
//    @EnvironmentObject var userVM: UserVM
    @StateObject var vm: CM_MainVM = CM_MainVM()
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
                          spacing: 20,content: {
                    if let unclassfied = vm.unclassfiedGroup{
                        
                        CM_GridItemView(isEditting: $isEditting, memo: "병해 진단 후 카테고리가 설정되지 않은 작물들입니다.", cnt: unclassfied.cnt, color: .lightGray, name: "미분류 그룹")
                    }
                    ForEach(vm.cm_GroupList) { item in
                        CM_GridItemView(isEditting: $isEditting, memo: item.memo, cnt: item.cnt, color: .lightAmbientColor, name: item.name)
                    }  
                })
                .padding()
                Spacer()
                Rectangle().fill(.clear).frame(height: 100)
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
