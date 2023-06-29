//
//  DiagnosisResultView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/05.
//

import SwiftUI
import Combine
import PopupView
import NativePartialSheet
struct DiagnosisResultView: View {
    enum ViewType{
        case Management
        case Response
        
    }
    enum SheetType:String, Identifiable{
        var id:String{
            return self.id
        }
        case MemoAdd
        case MemoEdit
        case Expert
    }
    private let screenWidth = UIScreen.main.bounds.width
    let diagnosisImage: Image
    let asynImageString: String
    let diagnosisResponse: DiagnosisResponse?
    let type: ViewType
    @StateObject var expertSheetVM: ExpertSheetVM = ExpertSheetVM()
    @StateObject var memoVM: MemoVM
    @State private var expertMessageActive = false
    @State private var goToNextView = false
    @State private var moreInfo:(String,Int)?
    @State private var showMemo: Bool = false
    @State private var sheetType: SheetType? = nil
    @State private var detent: Detent = .large
    @State private var deleteItem: Int? = nil
    @State private var editItem: Int? = nil
    @State private var deleteAlert: Bool = false
    init(image: Image,response: DiagnosisResponse?){
        self.diagnosisImage = image
        self.asynImageString = ""
        self.diagnosisResponse = response
        self.type = .Response
        if let recordId = diagnosisResponse?.diagnosisRecordID{
            self._memoVM = StateObject(wrappedValue: MemoVM(diagnosisID: recordId))
        }else{
            self._memoVM = StateObject(wrappedValue: MemoVM(diagnosisID: -1))
        }
    }
    init(response:DiagnosisResponse?){
        self.diagnosisImage = Image("logo_demo")
        self.asynImageString = response?.imagePath ?? ""
        self.diagnosisResponse = response
        self.type = .Management
        if let recordId = diagnosisResponse?.diagnosisRecordID{
            self._memoVM = StateObject(wrappedValue: MemoVM(diagnosisID: recordId))
        }else{
            self._memoVM = StateObject(wrappedValue: MemoVM(diagnosisID: -1))
        }
    }
    var body: some View{
        ZStack{
            NavigationLink(isActive: $goToNextView) {
                DiseaseInfoView(sickKey: self.moreInfo?.0 ?? "",
                                sickName:
                                    Diagnosis.koreanTable[
                                        DiagnosisType(rawValue: self.moreInfo?.1 ?? -1) ?? .none
                                    ] ?? ""
                                ,
                                cropName: Crop.koreanTable[CropType(rawValue: diagnosisResponse?.cropType ?? -1) ?? .none] ?? "")
            } label: {
                EmptyView()
            }
            VStack(spacing:8){
                ZStack{//MARK: -- 이미지 뷰
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: screenWidth - (self.showMemo ? 100 : 0)
                               ,height:screenWidth/1.2 - (self.showMemo ? 100 : 0))
                        .overlay {
                            //MARK: -- 이미지 표시하기
                            switch type{
                            case .Management:
                                AsyncImage(url:URL(string: self.asynImageString)){ phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(1,contentMode: .fit)
                                            .cornerRadius(8)
                                    case .failure:
                                        self.diagnosisImage
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(8)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            case .Response:
                                diagnosisImage
                                    .resizable()
                                    .padding(.horizontal)
                                    .frame(width: screenWidth)
                                    .clipped()
                            }
                        }
                }
                HStack(alignment:.center){//MARK: -- 인포 라인 뷰
                    Text("\(Crop.koreanTable[CropType(rawValue: self.diagnosisResponse?.cropType ?? -1)!] ?? "진단 실패")"
                    )
                    .font(.headline.bold())
                    .padding(.horizontal,8)
                    .padding(.vertical,4)
                    .foregroundColor(.white)
                    .background(Color.accentColor.opacity(0.6))
                    .cornerRadius(8)
                    Text(Date.changeDateFormat(dateString: self.diagnosisResponse?.regDate ?? "날짜 정보 없음")).font(.callout)
                        .padding(.bottom,2)
                    Spacer()
                    //MARK: -- 여기에 메모 기록 보는 네비게이션 뷰 이동
                    Button{
                        print("메모 보러가기")
                        withAnimation {
                            self.showMemo.toggle()
                        }
                    }label: {
                        HStack(spacing: 4){
                            HStack(spacing:3){
                                Image(systemName: "note.text")
                                Text("메모 기록")
                            }.font(.subheadline.bold())
                            Image(systemName: "chevron.right")
                                .imageScale(.medium)
                                .rotationEffect(.degrees(showMemo ? 90 : 0))
                        }
                    }.modifier(DiagnosisInfoViewModifier(paddingSize: 8))
                        .background(Color.lightAmbientColor)
                }
                .padding(.horizontal)
                ScrollView(showsIndicators: false){
                    if showMemo{
                        Divider().frame(height: 2)
                            .padding(.horizontal)
                        MemoListView(isShowMemo: $showMemo, deleteItem: $deleteItem, editingItem: $editItem)
                            .environmentObject(memoVM)
                            .transition(.opacity.animation(.easeInOut))
                            .zIndex(2)
                    }
                    Divider().frame(height: 2)
                        .padding(.horizontal)
                    diagnosisBody
                        .padding(.horizontal)
                        .zIndex(3)
                    Spacer()
                    Rectangle().frame(height: 120).foregroundColor(.white)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavTrailingBtn(btnAction: {
                    self.detent = .medium
                    sheetType = .MemoAdd
                }, imgName: "note.text.badge.plus", labelName: "메모 추가", textColor: .white, bgColor: .blue)
            }
        })
        .popup(isPresented: $expertSheetVM.isSendCompleted) {
            Text("요청을 전송했어요!!")
                .font(.subheadline).bold()
                .padding()
                .background(.white)
                .clipShape(Capsule())
                .background(Capsule().stroke(lineWidth:3).foregroundColor(.black))
        } customize: {
            $0.type(.floater())
                .position(.top).dragToDismiss(true)
                .closeOnTapOutside(true)
                .autohideIn(2)
        }
        .navigationBarBackground { Color.white }
    }
    //MARK: -- 진단 결과
    var diagnosisBody: some View{
        VStack(spacing:8){
            //MARK: -- 가장 유사한 결과
            GroupBox {
                if let result = self.diagnosisResponse?.diagnosisResults?[0]{
                    DiagnosisInfoView(accuracy:result.accuracy ?? 0,
                                      diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "-1"){
                        self.moreInfo = (result.sickKey ?? "",result.diseaseCode ?? -1)
                        
                        self.goToNextView = true
                    }
                }
            } label: {
                Text("가장 유사한 결과")
            }.bgColor(.white,paddingSize: 4)
            //MARK: -- 다른 유사 결과
            GroupBox {
                LazyVStack{
                    if let results: [DiagnosisItem] = self.diagnosisResponse?.diagnosisResults{
                        ForEach(results){ result in
                            if let first = results.first{
                                if result.id != first.id{
                                    DiagnosisInfoView(accuracy:result.accuracy ?? 0, diagnosisNumber:result.diseaseCode ?? -1,code:result.sickKey ?? "0"){
                                        self.moreInfo = (result.sickKey ?? "",result.diseaseCode ?? -1)
                                        self.goToNextView = true
                                    }
                                }
                            }
                        }
                    }
                }
            } label: {
                Text("다른 유사 결과")
            }.bgColor(.white,paddingSize: 4)
            GroupBox{
                Button{
                    self.detent = .large
                    self.sheetType = .Expert
                }label:{
                    HStack{
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18,weight: .semibold))
                            .imageScale(.large)
                            .padding(.trailing,4)
                        Text("진단 결과에 대해 더 궁금한게 있다면?\n전문가에게 질문을 남겨보세요!")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding(.trailing,12)
                    }
                    .padding()
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
                    .background(Color.accentColor.opacity(0.08))
                }.modifier(DiagnosisInfoViewModifier(paddingSize: 0))
            }.bgColor(.white,paddingSize: 4)
            //MARK: -- 수정 할 메모 아이템 변화 감지
            .onChange(of: editItem, perform: { newValue in
                    if newValue != nil{
                        self.detent = .medium
                        self.sheetType = .MemoEdit
                    }
                })
            .onChange(of: deleteItem, perform: { newValue in
                if newValue != nil{
                    deleteAlert = true
                }
            }).alert(isPresented: $deleteAlert, content: {
                Alert(title: Text("정말로 삭제하시겠습니까?"))
            })
            //MARK: -- 띄울 시트
                .sheet(item: $sheetType) { type in
                    switch type{
                    case .Expert:
                        ExpertMailView(diagnosisResponse: self.diagnosisResponse)
                            .environmentObject(expertSheetVM)
                            .onDisappear(){
                                self.sheetType = nil
                            }
                    case .MemoAdd:
                        MemoWriteView(type: .Add)
                            .environmentObject(memoVM)
                            .onDisappear(){
                            self.sheetType = nil
                        }
                    case .MemoEdit:
                        MemoWriteView(type: .Edit)
                            .environmentObject(memoVM)
                            .onDisappear(){
                                self.editItem = nil
                                self.sheetType = nil
                            }
                    }
                }.presentationDetents([.medium,.large],selection: $detent)
                .sheetColor(.white)
                .edgeAttachedInCompactHeight(true)
                .scrollingExpandsWhenScrolledToEdge(true)
                .widthFollowsPreferredContentSizeWhenEdgeAttached(true)
        }
    }
}

struct DiagnosisResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiagnosisResultView(response: nil)
        }
    }
}
