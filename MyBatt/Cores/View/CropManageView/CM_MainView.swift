//
//  CM_MainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI

struct CM_MainView: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var vm: CM_MainVM
    @State private var isEditting: Bool = false
    @State private var groupSettingSheet: Bool = false
    @State private var goNextView = false
    @State private var type: GroupSettingType = .Add
    @State private var nextViewGroup: (String,Int) = ("",0)
    var body: some View {
        ZStack{
            NavigationLink(isActive: $goNextView) {
                CM_CateListView(listName: self.nextViewGroup.0, id:self.nextViewGroup.1, groupModels: vm.getGroupDialogeList())
                    .environmentObject(vm)
                    
            } label: {
                EmptyView()
            }
            self.categoryGridView
            .sheet(isPresented: $groupSettingSheet, content: {
                CM_GroupSettingView(type: self.type,isEditting: $isEditting)
                    .environmentObject(vm)
                        .onDisappear(){
                            self.groupSettingSheet = false
                        }
                })
        }
        .onReceive(vm.goEditView, perform: { output in
            print(output)
            self.type = output
            if self.groupSettingSheet != true{
                self.groupSettingSheet = true
            }
        })
        .onReceive(vm.goToNextView, perform: { output in
            self.nextViewGroup = output
            self.goNextView = true
        })
            .navigationTitle("내 작물 관리")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(isEditting)
            .navigationBarBackground({ Color.white })
            .toolbar {
                //MARK: -- 그룹 추가
                ToolbarItem(placement:.navigationBarLeading){
                    if isEditting{
                        Button{
                            self.type = .Add
                            self.groupSettingSheet = true
                        }label: {
                            Image(systemName: "folder.badge.plus")
                        }.foregroundColor(.blue)
                            
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
    //MARK: -- 카테고리 그룹 그리드
    @ViewBuilder
    var categoryGridView: some View{
            ScrollView{
                LazyVGrid(columns: [GridItem(.flexible(),spacing: 20),GridItem(.flexible(),spacing: 20)],
                          spacing: 20,content: {
                    CM_GridItemView(isEditting: $isEditting, item: $vm.unclassfiedGroup, color: .lightGray,isUnclassfied: true)
                        .environmentObject(vm)
                    ForEach(vm.cm_GroupList.indices,id:\.self) { itemIdx in
                        let item = vm.cm_GroupList[itemIdx]
                        CM_GridItemView(isEditting: $isEditting, item: $vm.cm_GroupList[itemIdx],color:.lightAmbientColor)
                            .environmentObject(vm)
                                .overlay(alignment:.topLeading) {
                                    if isEditting{
                                        Button {
                                            print("삭제 아이콘 클릭")
                                            vm.deleteGroup(id: item.id,idx:itemIdx)
                                        } label: {
                                            itemRemoveView
                                        }
                                        .offset(x:-8,y:-4)
                                    }
                                }
                    }  
                })
                .onReceive(vm.addCompleted, perform: { output in
                    vm.getList()
                })
                .onReceive(vm.deleteCompleted, perform: { output in
                    vm.cm_GroupList.remove(at: output)
                })
                .padding()
                Spacer()
                Rectangle().fill(.clear).frame(height: 100)
            }
    }
    //MARK: -- 아이템들 삭제할 때 나오는 버튼
    @ViewBuilder
    var itemRemoveView: some View{
        Image(systemName: "minus.circle")
            .resizable()
            .aspectRatio(1,contentMode: .fit)
            .frame(width: 24)
            .foregroundColor(.red)
            .background(Circle().fill(.thickMaterial))
    }
}




struct CM_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CM_MainView()
        }
    }
}
