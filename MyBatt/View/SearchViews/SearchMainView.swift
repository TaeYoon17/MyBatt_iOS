//
//  SearchMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/21.
//

import SwiftUI


//struct SearchMainView: View  {
//    @State private var queryStr:String = ""
//    @State private var numbers = Array(repeating: 0, count: 100).enumerated().map{$0.offset}
//    var body: some View{
//        SearchNavigationView(searchQuery: $queryStr) {
//            LazyVStack(spacing:15) {
//                ForEach(numbers,id:\.self){idx in
//                    Text("\(idx) 입니다.")
//                        .swipeActions {
//                            Text("hello world")
//                        }
//                }
//                .onDelete(perform: { offset in
//                    numbers.remove(atOffsets: offset)
//                })
//                .padding(.top,10)
//            }
//        }
//    }
//}
struct SearchMainView: View{
    @State private var queryStr: String = ""
    @State private var numbers = Array(repeating: 0, count: 100).enumerated().map{$0.offset}
    @State private var selectedColor = "Red"
    @State private var headerHeight = 0
    let colors = ["Red", "Green", "Blue"]
    var body:some View{
        List{
            ForEach(numbers,id:\.self){ idx in
                Text("\(idx) 입니다.")
            }.onDelete { idx in
                numbers.remove(atOffsets: idx)
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("검색")
        .onChange(of: queryStr) { newValue in
            print(newValue)
            print("wow world")
        }
        .searchable(text: $queryStr,placement: .navigationBarDrawer(displayMode: .always))
        .animation(.easeIn(duration: 0.5), value: selectedColor)
    }
    
}

struct SearchMainView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMainView()
    }
}
