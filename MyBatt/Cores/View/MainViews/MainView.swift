//
//  MainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/10.
//

import SwiftUI
enum MainLinkViewType{
    case OutBreakInfo, Map,CropManage,Camera,Search,MyInfo,ExpertRequest,
         Album,Diagnosis
    case none
}

struct MainView: View {
    @Binding var isCameraActive: Bool
    @State private var pickerNumber = 1
    @EnvironmentObject var appManager:AppManager
    @EnvironmentObject var userVM: UserVM
    @StateObject var cm_mainVM = CM_MainVM()
    @State var linkView = MainLinkViewType.none
    @State var naviStackIdx = 0
    @State var isAnimating = false
    //    @Binding var naviStackIdx: Int
    var body: some View {
        NavigationView {
            ZStack{
                self.naviLinkController
                    .onReceive(appManager.mainViewLink) { nextType in
                        self.activeLink(nextType)
                    }
                ScrollView(showsIndicators:false){
                    VStack(spacing:25){
                        //MARK: -- 병해 발생 정보
                        GroupBox {
                            MainOutBreakInfoView()
                        } label: {
                            HStack(alignment:.lastTextBaseline){
                                Text("병해 발생 정보").font(.title2.bold())
                                Spacer()
                                Link(destination: URL(string:"https://ncpms.rda.go.kr/mobile/NewIndcUserListR.ms")!) {
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
                            MainManagementBtn(itemList: cm_mainVM.getMainViewGroupListInfo()) {
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
                            .cornerRadius(10)
                        
                        HStack(alignment: .top,spacing:20){
                            //MARK: -- 도움말
                                MainRequestBtn(labelImage: "questionmark.circle.fill",
                                               labelText: "서비스 가이드"){
                                    if let url = URL(string: "https://www.youtube.com/watch?v=RTHg8laviaM") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            
                            MainRequestBtn(labelImage: "headphones",
                                           labelText: "전문가에게 추가 문의하기"){
                                activeLink(.ExpertRequest)
                            }
                        }.frame(minHeight: 80)
                    }.cornerRadius(10)
                    Spacer()
                }
                .padding()
            }
            .opacity(isAnimating ? 1 : 0)
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
            })
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
            .onAppear(){
                withAnimation(.easeOut(duration: 0.8)){
                    isAnimating.toggle()
                }
            }
            .onDisappear(){
                withAnimation {
                    isAnimating.toggle()
                }
            }
    }
    var naviLinkController: some View{
        NavigationLink(isActive:appManager.getBindingStack(idx: naviStackIdx)){
            switch linkView {
            case .OutBreakInfo:
                Text("OutBreakInfo")
            case .Map:
                MapMainView()

            case .CropManage:
                CM_MainView()
                    .environmentObject(cm_mainVM)
            case .Camera:
                Text("EmptyView")
            case .Search:
                SearchMainView()
            case .Album:
                AlbumPickerView()
                    .onDisappear(){
                        self.appManager.isTabbarHidden = false
                        if appManager.isDiagnosisActive{
                            self.activeLink(.Diagnosis)
                        }
                    }
            case .Diagnosis:
                DiagnosisView()
                    .onDisappear(){
                        self.appManager.isDiagnosisActive = false
                    }
            case .none:
                Text("None View")
            case .MyInfo:
                InfoMainView().onDisappear(){
                    appManager.isMyInfoActive = false
                }
            case .ExpertRequest:
                ExpertMainView()
            }
        } label: {
            EmptyView()
        }
        .isDetailLink(false)
        .fullScreenCover(isPresented: $appManager.isCameraActive) {
            CameraView().onDisappear(){
                if appManager.isAlbumActive {
                    self.activeLink(.Album)
                }
                if appManager.isDiagnosisActive{
                    self.activeLink(.Diagnosis)
                }
            }
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
            .environmentObject(UserVM())
        //                 , naviStackIdx: .constant(0)
    }
}
