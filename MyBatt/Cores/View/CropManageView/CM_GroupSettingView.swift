//
//  CM_GroupAddView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import SwiftUI
enum GroupSettingType{
    case Edit(id: Int,name: String, memo: String)
    case Add
}
struct CM_GroupSettingView: View {
    @State private var groupName: String = ""
    @State private var memo: String = ""
    @State private var groupID: Int = 0
    @Environment(\.dismiss) private var dismiss
    @Binding var isEditting: Bool
    @EnvironmentObject var vm: CM_MainVM
    let groupSettingType: GroupSettingType
    init(type: GroupSettingType, isEditting: Binding<Bool>){
        self.groupSettingType = type
        self._isEditting = isEditting
        switch type{
        case let .Edit(id: id, name: name, memo: memo):
            print("EditTypeCalled")
            self._groupName = State(wrappedValue: name)
            print(self.groupName)
            self._groupID = State(wrappedValue: id)
            self._memo = State(wrappedValue: memo)
        case .Add: break
        }
    }
    var body: some View {
        NavigationView {
            VStack{
                VStack(spacing: 8){
                    VStack(alignment:.leading,spacing:4){
                        Text("그룹 이름").font(.title3).bold()
                            .padding(.all,8)
                        TextField("그룹 이름을 입력하세요",text: self.$groupName)
                            .font(.title.bold())
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .background(Color.lightGray)
                    .cornerRadius(8)
                    Divider().frame(height:1)
                    VStack(alignment: .leading,spacing:4) {
                        Text("메모 내용").font(.title3).bold()
                            .padding(.all,8)
                        TextEditor(text: $memo)
                            .font(.system(size: 18))
                            .frame(height: 180)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .background(Color.lightGray)
                    .cornerRadius(8)
                }.padding()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("내 작물 관리")
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading){
                    Button{
                        print("취소버튼 눌림")
                        self.dismiss()
                        self.isEditting = false
                    }label:{
                        Text("취소")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        switch self.groupSettingType{
                        case .Add:
                            vm.addGroup(name: self.groupName, memo: self.memo)
                        case let .Edit(id: id, name: _, memo: _):
                            vm.editGroup(id: id, newName: self.groupName, newMemo: self.memo)
                        }
                        self.dismiss()
                        self.isEditting = false
                    }label:{
                        Text("완료")
                    }.tint(.blue)
                    .disabled(groupName == "")
                }
            }
        }
    }
}

struct CM_GroupAddView_Previews: PreviewProvider {
    static var previews: some View {
        CM_GroupSettingView(type: .Add,isEditting: .constant(true))
    }
}
