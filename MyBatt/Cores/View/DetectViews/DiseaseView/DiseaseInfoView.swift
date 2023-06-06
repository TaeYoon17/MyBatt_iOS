//
//  DiseaseInfoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/02.
//

import SwiftUI
private enum InfoType:CaseIterable{
    case PictureType
    case EnvironmentType
    case Symptom
}
struct DiseaseInfoView: View {
    @State private var toggleStates = [true,true,true,true]
    @State private var goNextView = false
    @State private var imageWidth: CGFloat = 0
    var body: some View {
        VStack(spacing:0){
            NavigationLink(isActive: $goNextView) {
                GeometryReader{ proxy in
                    let topInset = proxy.safeAreaInsets.top
                    PesticideListView(topInset: topInset)
                }
            } label: {
                EmptyView()
            }
            //MARK: -- 헤더 뷰
            HStack(alignment:.center, spacing:4){
                ScrollView(.horizontal){
                    Text("버거씨 병")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            ScrollView(showsIndicators: false){
                VStack(spacing: 12){
                    self.imageInfo
                    self.textInfoView(text: "병원 균은 뭐ㅜ머러민ㅇ럼니", label: "발생환경",toggleState: $toggleStates[1])
                    self.textInfoView(text: "병원 균은 뭐ㅜ머러민ㅇ럼니", label: "증상",
                                      toggleState: $toggleStates[2])
                    self.textInfoView(text: "와라랄라라라라랄라라라\nasdfasdfasd\nasdfsadfasdf\nasdfasdf\nsadfasdfaf\nsadfsad\nasfdasdf\nsadfasd\nsadfasdf\nsadfas", label: "방제방법",
                                      toggleState: $toggleStates[3])
                    Rectangle().fill(Color.white).frame(height:100)
                }.padding(.all)
            }
        }
        .padding(.vertical)
        .background(Color.white)
        .navigationTitle("병해정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                Button{
                    print("관련 농약 버튼 클릭!!")
                    self.goNextView = true
                }label: {
                    HStack(spacing:4){
                        Image(systemName: "cross.case")
                            .imageScale(.small)
                        
                        Text("농약 정보")
                            .font(.system(size:16).weight(.semibold))
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.all,2)
                .background(Color.accentColor.opacity(0.8))
                .cornerRadius(8)
            }
        }
    }
}

//MARK: -- 사진 정보
extension DiseaseInfoView{
    var imageInfo: some View {
        DisclosureGroup(isExpanded: $toggleStates[0]) {
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    Image("picture_demo").resizable().aspectRatio(1,contentMode: .fit).frame(width: imageWidth)
                        .cornerRadius(8)
                    Image("picture_demo").resizable()
                        .aspectRatio(1,contentMode: .fit).frame(width: imageWidth)
                        .cornerRadius(8)
                    Image("picture_demo").resizable().aspectRatio(1,contentMode: .fit).frame(width: imageWidth)
                        .cornerRadius(8)
                    Image("picture_demo").resizable().aspectRatio(1,contentMode: .fit).frame(width: imageWidth)
                        .cornerRadius(8)
                    Image("picture_demo").resizable().aspectRatio(1,contentMode: .fit).frame(width: imageWidth)
                        .cornerRadius(8)
                }
            }
            .background(GeometryReader{
                proxy in
                Color.clear.onAppear(){
                    self.imageWidth = proxy.size.width / 1.6
                 
                }
            })
            .padding(.all,8)
            .background(.white)
            .padding(.top,4)
            .cornerRadius(12)
            
        } label: {
            Text("사진정보").font(.title2.weight(.heavy))
        }
        .padding()
        .background(Color.lightGray)
        .cornerRadius(12)
    }
}
// MARK: -- 발생환경, 증상 뷰
extension DiseaseInfoView{
    @ViewBuilder
    func textInfoView(text:String,label:String,toggleState: Binding<Bool>)-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            HStack{
                Text(text)
                Spacer()
            }.padding(.all,12)
                .background(.white)
                .padding(.top,4)
                .cornerRadius(12)
        } label: {
            HStack{
                Text(label)
                    .font(.title2.weight(.heavy))
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(12)
        
    }
}
struct DiseaseInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiseaseInfoView()
        }
    }
}
