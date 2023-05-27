//
//  ExpertMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import SwiftUI

struct ExpertMainView: View {
    @State var users = ["hello","my","name","is","life","good"]
    @State private var isAdd = false
    var body: some View {
        List{
            Section {
                ForEach(users,id:\.self){ user in
                    Button{
                        print("Hello world")
                    } label:{
                        Text(user)
                    }
                }.onDelete { idx in
                    users.remove(atOffsets: idx)
                }
            } header: {
                Text("요청 중인 메시지")
            }
            Section {
                ForEach(users,id:\.self){ user in
                    Button{
                        print("Hello world")
                    } label:{
                        Text(user)
                    }
                }.onDelete { idx in
                    users.remove(atOffsets: idx)
                }
            } header: {
                Text("응답 온 메시지")
            }
            .listStyle(.plain)
        }
        .navigationTitle("전문가 문의")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button{
                    self.isAdd.toggle()
                }label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $isAdd
                       , content: {
                    ExpertMailView()
                })
            })
        }
    }
}

struct ExpertMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMainView()
        }
        
    }
}
