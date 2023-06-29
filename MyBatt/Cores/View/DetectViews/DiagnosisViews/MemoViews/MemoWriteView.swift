//
//  AddMemoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/29.
//

import SwiftUI

struct MemoWriteView: View {
    enum WriteType{
        case Add
        case Edit
    }
    @EnvironmentObject var vm:MemoVM
    @State private var userText = ""
    @Environment(\.dismiss) private var dismiss
    let type:WriteType
    let memoId: Int?
    init(type: WriteType,memoId: Int? = nil){
        self.type = type
        self.memoId = memoId
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                GeometryReader{ proxy in
                    TextEditor(text: $userText)
                        .font(.system(size: 22))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .colorMultiply(Color.lightGray)
                        .cornerRadius(8)
                        .overlay {
                            if userText == ""{
                                Text("여기에 입력하세요.")
                            }
                        }
                }
                Button {
                    guard userText != "" else { return }
                    switch type{
                    case .Add:
                        vm.addMemo(contents: self.userText)
                    case .Edit:
                        vm.editMemo(memoId: self.memoId ?? -1)
                    }
                    self.dismiss()
                } label: {
                    HStack{
                        Spacer()
                        Label(self.type == .Add ? "추가" : "수정",
                              systemImage: self.type == .Add ? "note.text.badge.plus" : "note.text")
                            .font(.headline.bold()).foregroundColor(.white)
                        Spacer()
                    }.padding(.vertical,8)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .tint( self.type == .Add ? .blue : .accentColor)
                .disabled(userText == "")
            }.padding()
                .navigationTitle("메모 \(self.type == .Add ? "추가" : "수정")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoWriteView(type: .Add)
    }
}
