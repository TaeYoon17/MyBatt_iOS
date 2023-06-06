//
//  ExpertMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import SwiftUI
fileprivate enum ExpertSheetType:Identifiable{
    var id:Self{
        return self
    }
    case Info
    case Request
}
struct ExpertMainView: View {
    @State var users = ["hello","my","name","is","life","good"]
    @State private var toggleStates = [true,true,true,true]
    @State private var isAdd = false
    @State private var sheetType: ExpertSheetType? = nil
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 12){
                self.textInfoView(
                    label: "요청 중인 메시지",toggleState: $toggleStates[1]){
                        LazyVStack(spacing:8){
//                            Rectangle().fill(Color.white).frame(height:0)
                            ForEach(0...12,id:\.self){ _ in
                                Button{
                                    self.sheetType = .Info
                                }label: {
                                    demoItem
                                }.buttonStyle(.plain)
                                    .cornerRadius(8)
//                                Divider().frame(height: 1).foregroundColor(.secondary)
                            }
                        }
//                        .background(.white)
                                .padding(.vertical,12)
                            .cornerRadius(8)
                    }
                self.textInfoView(label: "응답 온 메시지",toggleState: $toggleStates[3]){
                    Text("Hello world")
                }
                Rectangle().fill(Color.white).frame(height:100)
            }.padding(.all)
            //MARK: -- Sheet Router
            .sheet(item: $sheetType){ item in
//                let item:ExpertSheetType? = item
                switch item{
                case .Info: ExpertMsgView()
                        .onDisappear(){
                            sheetType = nil
                        }
                case .Request: ExpertMailView()
                        .onDisappear(){
                            sheetType = nil
                        }
                }
            }
        }
        
        .navigationTitle("전문가 문의")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button{
                    self.sheetType = .Request
                }label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
            })
        }
//        .sheet(isPresented: $isAdd
//               , content: {
//            ExpertMailView()
//        })
        
    }
    var demoItem: some View{
        HStack(spacing: 16){
            Image("logo_demo")
                .resizable()
                .scaledToFit()
                .background(Color.ambientColor)
                .cornerRadius(8)
            VStack(alignment: .leading,spacing: 4){
                HStack(alignment:.top){
                    Text("제목:").font(.headline)
                    Text("토마토 버거씨병 같은데 아니레용asdfasdfasdfasfasf").font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }.padding(.top,4)
                HStack(alignment:.top){
                    Text("병해:").font(.headline)
                    Text("고추 마일드 모틀바이러스").font(.subheadline)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("52%").font(.subheadline)
                    Text("토마토")
                    Text("2023.06.04 20:24")
                }
                .font(.footnote)
                .padding(.trailing,8)
                .padding(.bottom,4)
//                .background(Color.blue)
                    
                
//                Spacer()
            }
            
        }
//        .padding(.vertical,12)
        .background(Color.white)
        .frame(height: 100)
        
    }
}
extension ExpertMainView{
    @ViewBuilder
    func textInfoView(label:String,toggleState: Binding<Bool>,
                      @ViewBuilder _ view:@escaping (() -> some View))-> some View{
        DisclosureGroup(isExpanded: toggleState) {
            view()
        } label: {
            HStack{
                Text(label)
                    .font(.title2.weight(.bold))
                Spacer()
            }
        }
        .padding(.all)
        .background(Color.lightGray)
        .cornerRadius(8)
    }
}
struct ExpertMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMainView()
        }
        
    }
}
