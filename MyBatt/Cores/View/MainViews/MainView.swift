//
//  MainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/10.
//

import SwiftUI
enum MainLinkViewType{
    case OutBreakInfo
    case Map
    case CropManage
    case Camera
    case Search
    case none
    //    func goLink()->some View{
    //        switch self{
    //        case .Camera: return Text("Hello World")
    //        case .CropManage: return CameraView()
    //        default: return EmptyView()
    //        }
    //    }
}

struct MainView: View {
    @Binding var isCameraActive: Bool
    @State private var pickerNumber = 1
    @EnvironmentObject var appManager:AppManager
    @State var linkView = MainLinkViewType.none
    @State var naviStackIdx = 0
//    @Binding var naviStackIdx: Int
    var body: some View {
        NavigationView {
            ZStack{
                self.naviLinkController
                ScrollView(showsIndicators:false){
                    VStack(spacing:25){
                        //MARK: -- 병해 발생 정보
                        GroupBox {
                            MainOutBreakInfoView()
                        } label: {
                            HStack(alignment:.lastTextBaseline){
                                Text("병해 발생 정보").font(.title2.bold())
                                Spacer()
                                Button{
                                    self.activeLink(.OutBreakInfo)
                                }label:{
                                    Text("전체 보기")
                                        .font(.footnote.weight(.semibold))
                                        .underline()
                                }
                            }
                        }
                        .groupBoxStyle(GroupBoxBackGround(color: Color.lightGray))
                        HStack(alignment:.top,spacing:20){
                            //MARK: -- 주변 정보 지도 보기
                            MainMapBtn {
                                activeLink(.Map)
                            }.shadow(radius: 5,x:3,y:3)
                                .scaledToFit()
                            //MARK: -- 내 작물 관리
                            MainManagementBtn {
                                self.activeLink(.CropManage)
                            }
                        }
                        //MARK: -- 병해 정보 검색
                        MainSearchBtn {
                            self.activeLink(.Search)
                        }.padding(.horizontal)
                            .foregroundColor(.black)
                            .frame(minHeight: 60,maxHeight: 80)
                            .background(Color.lightGray)
                        
                        //MARK: -- 도움말
                        HStack(alignment: .top,spacing:20){
                            //                                ScrollView{
                            //                                    Text("wow world")
                            //                                }.navigationTitle("Hello World").searchable(text: .constant("여기에서 검색"))
                            //                                    .navigationBarTitleDisplayMode(.large)
                            
                            MainRequestBtn(labelImage: "questionmark.circle.fill",
                                           labelText: "서비스 가이드"){
                                activeLink(.none)
                            }
                            MainRequestBtn(labelImage: "headphones",
                                           labelText: "전문가에게 추가 문의하기"){
                                activeLink(.none)
                            }
                        }.frame(minHeight: 80)
                    }.cornerRadius(10)
                    Spacer()
                }
                .padding()
            }
            .disabled(appManager.getBindingStack(idx: self.naviStackIdx).wrappedValue)
            .disabled(appManager.isAction)
            .toolbar(content: {
                ToolbarItem(id: "Title",placement: .navigationBarLeading) {
                    //여기 폰트 수정
                    Text("내 밭을 부탁해").font(.title2.weight(.black))
                        .foregroundColor(.accentColor)
                        .padding(.vertical)
                }
                ToolbarItem(placement:.navigationBarLeading){
                    LottieView(fileName: "TitleLeaf", loopMode: .repeat(2))
                        .frame(width: 32,height: 32)
                        .offset(x:-10)
                }
                ToolbarItem(id: "Alert",placement: .navigationBarTrailing) {
                    Image(systemName: "bell").foregroundColor(.accentColor)
                        .font(.system(.body).bold())
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
    var naviLinkController: some View{
        NavigationLink(isActive:appManager.getBindingStack(idx: naviStackIdx)){
                switch linkView {
                case .OutBreakInfo:
//                    Text("OutBreak View")
                    CoinImageView(coin: globalCoinDemo)
                case .Map:
                    MapMainView()
                case .CropManage:
                    Text("Crop Manage View")
                case .Camera:
                    Text("EmptyView")
                case .Search:
                    SearchMainView()
                case .none:
                    Text("None View")
                }
        } label: {
//            Text(self.naviStackIdx.description)
            EmptyView()
        }
            .isDetailLink(false)
            .fullScreenCover(isPresented: $appManager.isCameraActive) {
                CameraView()
            }
    }
}


extension MainView{
    func activeLink(_ viewType: MainLinkViewType){
        self.linkView = viewType
        self.naviStackIdx = appManager.linkAction()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(isCameraActive: .constant(false))
            .environmentObject(AppManager())
//                 , naviStackIdx: .constant(0)
    }
}
