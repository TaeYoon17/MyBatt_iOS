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
    @EnvironmentObject var appManager: AppManager
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        GeometryReader { proxy in
            let insets = proxy.safeAreaInsets
            _SearchMainView(topInset: insets.top)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationTitle("작물 검색하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}


extension SearchMainView{
    var prevView: some View{
        VStack{
            SearchedView()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("병해 정보 검색")
            Rectangle().frame(height:100).foregroundColor(.white)
        }
        .navigationBarTitleDisplayMode(.large)
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
            oo.requestSickList(cropName: searchTerm, sickNameKor: nil, displayCount: nil, startPoint: nil)
        }
    }
}


struct SearchMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SearchMainView()
        }
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
                            .scaledToFit().frame(width:80)
                            .foregroundColor(.gray)
                        Text("작물 이름을 입력하세요!!")
                    }
                }else{
                    Text("검색하기 전 기본 뷰")
                }
            }
        }
    }
}
struct _SearchMainView: View {
    let topInset: CGFloat
    @Namespace var animation
    
    @State private var cropNameField:String = ""
    @State private var diseaseNameField:String = ""
    @State var isShow = true
    @State private var goNextView:Bool = false
    var body: some View {
        VStack(spacing:0){
            NavigationLink(isActive: $goNextView) {
                DiseaseInfoView()
            } label: {
                EmptyView()
            }
            // App Bar...
            self.appBar
            // Content....
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0){
                    // geometry reader for getting location values...
                    self.scrollReader.frame(height: 0)
                    // MARK: -- 콘텐츠 배치
                    Rectangle().fill(.white).frame(height: 12)
                    LazyVStack(spacing: 12) {
                        ForEach(1...10,id:\.self){_ in
                            Button{
                                self.goNextView = true
                            } label: {
                                SearchItemView()
                                    .padding()
                                    .background(Color.lightGray)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                //MARK: -- 아래 패딩
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 160)
            }
            .background()
            .coordinateSpace(name: "content")
        }
    }
    var scrollReader: some View{
        GeometryReader{ proxy -> AnyView in
            let yAxis: CGFloat = proxy.frame(in: .named("content")).minY
            if 0 > yAxis && isShow{
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isShow = false
                    }
                }
            }
            if 0 < yAxis && !isShow{
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isShow = true
                    }
                }
            }
            return AnyView(
                Text("").frame(width: 0,height:0)
            )
        }
    }
}
private extension _SearchMainView{
    var appBar: some View{
        VStack(spacing:0){
            if isShow{
                HStack(alignment:.bottom, spacing:4){
                    Text("21개 ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    ScrollView(.horizontal){
                        Text("토마토 버거씨병")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
            }
            HStack{
                VStack(alignment:.leading,spacing:4){
                    Text("작물명").font(.subheadline).bold()
                        .padding(.leading,4)
                    TextField("작물명",text: $cropNameField)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
                VStack(alignment: .leading,spacing:4){
                    Text("병해명").bold().font(.subheadline)
                        .padding(.leading,4)
                    TextField("병해명",text: $diseaseNameField)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding()
            .background(Color.lightGray)
            .padding(.top)
            HStack(alignment: .center, spacing: 24){
                HStack{
                    Text("이미지")
                    Spacer()
                }
                    .frame(width: 60)
                HStack{
                    Text("작물명")
                    Spacer()
                }
                    .frame(width: 70)
                Text("병해명")
                Spacer()
            }
            .font(.headline.weight(.semibold))
            .padding(.vertical,8)
            .padding(.horizontal)
            .padding(.horizontal)
            .background(.gray.opacity(0.2))
        }
        .padding(.top,topInset)
    }
}
