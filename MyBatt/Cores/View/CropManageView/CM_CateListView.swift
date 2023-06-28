//
//  CM_CateListView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/04.
//

import SwiftUI


struct DemoModel:Identifiable,Hashable{
    var id = UUID()
    var number: Int
}
struct CM_GroupModel:Identifiable{
    var id = UUID()
    let groupId: Int
    let name: String
}
struct CM_CateListView: View {
    @State private var isMoving = false
    @State var selectedItems:Set<Int> = []
    @Environment(\.editMode) var editMode
    @State private var isEditting = false
    @State private var goToNextView = false
    @StateObject private var vm: CM_GroupVM
    @EnvironmentObject var mainVM: CM_MainVM
    @State private var itemId: Int = 0
    let id:Int
    let listName: String
    let groupDialogItems: [CM_GroupModel]
    init(listName: String,id: Int,groupModels: [CM_GroupModel]){
        self.listName = listName
        self.id = id
        self.groupDialogItems = groupModels
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
        self._vm = StateObject(wrappedValue: CM_GroupVM(id: id))
    }
    var body: some View {
        ZStack{
            NavigationLink(isActive: $goToNextView){
                DiagnosisResultView(response: vm.cm_diagnosisItem)
                    .navigationTitle("병해 진단 결과")
                    .navigationBarTitleDisplayMode(.inline)
            }label:{
                EmptyView()
            }
            .onReceive(vm.diagnosisResponseCompleted) { _ in
                goToNextView = true
            }
            List (vm.cm_groupItems,selection:$selectedItems){ item in
                if item.id == 0{
                    Rectangle().fill(Color.clear).frame(height:100)
                }else{
                    Button{
                        self.vm.getDiagnosisItem(id: item.id)
                    }label:{
                        ItemView(item: item)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                        Button{
                            self.itemId = item.id
                            isMoving.toggle()
                        }label:{
                            Label("이동",systemImage: "arrowshape.turn.up.left.circle")
                        }.tint(.accentColor)
                    })
                    //MARK: -- 작물 기록 삭제
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button {
//                            print("삭제 할 수 있음")
//                        } label: {
//                            Label("삭제", systemImage: "star.circle")
//                        }
//                        .tint(.red)
//                    }
                    .listRowSeparator(.hidden)
                    .background(Color.lightGray)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom,120)
            .listStyle(.plain)
        }
        
        .onReceive(self.vm.changeGroupCompleted, perform: { _ in
            mainVM.getList()
        })
        .navigationBarBackground({
            Color.white
        })
        .navigationTitle(self.listName == "unclassified" ? "미분류 그룹" : self.listName)
        .navigationBarBackButtonHidden(isEditting)
        .navigationBarTitleDisplayMode(.large)
        //MARK: -- Navigation Bar 설정
        .toolbar {
            ToolbarItemGroup(placement:.navigationBarLeading) {
                if isEditting{
                    Button{
                        print("작물 카테고리 이동")
                    }label:{
                        Text("그룹 이동")
                    }
                    Button{
                        print("삭제하기가 불렸다")
                    }label:{
                        Text("삭제")
                    }.tint(Color.red)
                }
            }
//            ToolbarItem(placement:.navigationBarTrailing) {
//                EditButton()
//            }
        }
        .onChange(of: editMode?.wrappedValue, perform: { newValue in
            isEditting.toggle()
        })
        .confirmationDialog("작물 이동", isPresented: $isMoving) {
            ForEach(self.groupDialogItems) { item in
                if item.groupId != self.vm.id{
                    Button(item.name == "unclassified" ? "미분류 그룹" : item.name) {
                        let idx = vm.cm_groupItems.firstIndex { item in
                            item.id == self.itemId
                        }
                        if let index = idx{
                            vm.cm_groupItems.remove(at: index)
                        }
                        vm.changeItemGroup(toGroupId: item.groupId, itemId: self.itemId)
                    }.buttonStyle(.plain)
                }
            }
            Button("취소", role: .cancel) {
                print("취소")
                isMoving.toggle()
            }
        }
    }
}
fileprivate struct ItemView:View{
    let item: CM_GroupItem
    var body: some View{
        HStack(spacing: 16){
            AsyncImage(url: URL(string: item.imgPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading,spacing: 4){
                HStack{
                    Text(Crop.koreanTable[item.cropType] ?? "").font(.headline)
                    Text(item.regDate).font(.subheadline)
                    Spacer()
                }
                .padding(.top,12)
                HStack{
                    Text("병해:").font(.headline)
                    Text("\(Diagnosis.koreanTable[item.diseaseType] ?? "") (\(Int(item.accuracy*100))%)").font(.subheadline)
                    Spacer()
                }
                if true{
                    HStack(alignment: .top){
                        Text("위치:").font(.subheadline).bold()
                        VStack(alignment:.leading,spacing:4){
                            Text(item.address)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 15))
                        }
                        Spacer()
                    }
                }
                Spacer()
                Spacer()
            }.overlay(alignment:.topTrailing){
                Image(systemName: "chevron.right")
                    .padding(.top,16)
            }
            
        }
        .padding(.all,12)
        .frame(height: 120)
    }
}
struct CM_CateListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CM_CateListView(listName:"마법의 소라고동",id: 10, groupModels: [])
        }
    }
}
