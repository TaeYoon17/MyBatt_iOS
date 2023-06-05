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

struct CM_CateListView: View {
    @State private var items = [DemoModel(number: 0),DemoModel(number: 1),DemoModel(number: 2)]
    @State private var isMoving = false
    @State var selectedItems:Set<UUID> = []
    @Environment(\.editMode) var editMode
    @State private var isEditting = false
    @State private var goToNextView = false
    var body: some View {
        ZStack{
            NavigationLink(isActive: $goToNextView){
                DiagnosisResultView(diagnosisImage: Image("logo_demo"), diagnosisResponse: DiagnosisResponse(cropType: 1, id: 3, diagnosisRecordID: 1, userID: 1, userLongitude: 0.123, userLatitude: 0.123, imagePath: nil, diagnosisResults: [DiagnosisItem(diseaseCode: 0, accuracy: 0.44, sickKey: nil, boxX1: 0, boxX2: 0, boxY1: 0, boxY2: 0)]))
                    .navigationTitle("병해 진단 결과")
                    .navigationBarTitleDisplayMode(.inline)
            }label:{
                EmptyView()
            }
            List (items,selection:$selectedItems){ item in
                Button{
                    print("버튼 선택")
                    goToNextView = true
                }label:{
                    demoItem
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                    Button{
                        isMoving.toggle()
                    }label:{
                        Label("이동",systemImage: "arrowshape.turn.up.left.circle")
                    }.tint(.accentColor)
                })
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        print("삭제 할 수 있음")
                    } label: {
                        Label("삭제", systemImage: "star.circle")
                    }
                    .tint(.red)
                }
                .listRowSeparator(.hidden)
                .background(Color.lightGray)
                .cornerRadius(8)
            }
            .listStyle(.plain)
        }
        .navigationTitle("미분류 작물")
        .navigationBarBackButtonHidden(isEditting)
        .navigationBarTitleDisplayMode(.large)
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
            ToolbarItem(placement:.navigationBarTrailing) {
                EditButton()
            }
        }
        .onChange(of: editMode?.wrappedValue, perform: { newValue in
            isEditting.toggle()
        })
        .confirmationDialog("작물 이동", isPresented: $isMoving) {
            ForEach(items) { item in
                Button(item.number.description, role: .destructive) {
                    print("선택")
                }
            }
            Button("취소", role: .cancel) {
                print("취소")
                isMoving.toggle()
            }
        }
    }
    var demoItem: some View{
        HStack(spacing: 16){
            Image("logo_demo")
                .resizable()
                .scaledToFit()
                .background(Color.ambientColor)
                .cornerRadius(8)
            VStack(alignment: .leading,spacing: 4){
                HStack{
                    Text("토마토").font(.headline)
                    Text("2023.06.04 20:24").font(.subheadline)
                    Spacer()
                }
                .padding(.top,12)
                HStack{
                    Text("병해:").font(.headline)
                    Text("잎 곰팡이병 (52%)").font(.subheadline)
                    Spacer()
                }
                if true{
                    HStack(alignment: .top){
                        Text("메모:").font(.subheadline).bold()
                        VStack(alignment:.leading,spacing:4){
                            Text("나 이거 잘 \n못 sdfasdfasdfasdfasdfasdfasdf찍었다!!\n 내가 너 이럴 줄 알았다...asdfasdfasdfasddasdfasdfasdfasdf")
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
            //            .background(Color.blue)
            
        }
        .padding(.all,12)
        .frame(height: 120)
    }
}

struct CM_CateListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CM_CateListView()
        }
    }
}
