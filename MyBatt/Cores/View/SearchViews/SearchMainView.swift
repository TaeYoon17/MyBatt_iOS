//
//  SearchMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/21.
//

import SwiftUI
struct SearchMainView: View{
    @State private var searchTerm = ""
    @StateObject var oo = SeaerchMainVM()
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    var body: some View {
        NavigationView{
            VStack{
                SearchedView()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("병해 정보 검색")
                Rectangle().frame(height:100).foregroundColor(.white)
            }
        }
        .searchable(text: $searchTerm){
            ForEach(oo.searchResults) { item in
                HStack{
                    Text("\(item.name)-\(item.title)")
                        .foregroundColor(.black)
                }.frame(height: 100)
                .padding(.vertical,4)
            }
        }
        .onChange(of: searchTerm) { newValue in
            print(isSearching)
            if searchTerm.isEmpty && !isSearching {
                //Search cancelled here
                print("검색 취소")
            }
            oo.searchResults = oo.data.filter({ item in
                item.name.lowercased().contains(newValue.lowercased())
            })
        }.onSubmit(of:.search) {
            print(isSearching)
            print("검색 실행")
        }
    }
    
}

struct SearchMainView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMainView()
    }
}
fileprivate struct SearchedView: View {
    @Environment(\.isSearching) private var isSearching
    var body: some View {
        ZStack{
            VStack{
                if isSearching{
                    VStack(spacing:20){
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit().frame(width:100)
                        Text("궁금하면 물어봐!!")
                    }
                }else{
                    Text("검색하기 전 기본 뷰")
                    }
                }
        }
    }
}
