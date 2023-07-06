//
//  ExpertMailView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/27.
//

import SwiftUI

struct ExpertMailView: View {
    @State private var message = ""
    @State private var title = ""
    @State private var isSelected = false
    @State private var diagnosisResponse:DiagnosisResponse?
    @State private var goNextView: Bool = false
    @State private var isDismiss:Bool = false
    //외부에 passthroughSubject로 성공 여부를 전송하기 때문
    @EnvironmentObject var vm : ExpertSheetVM
    @Environment(\.dismiss) private var dismiss
    init(diagnosisResponse: DiagnosisResponse? = nil){
        self._diagnosisResponse = State(wrappedValue: diagnosisResponse)
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 8){
                //MARK: -- 헤더
                HStack{
                    Text(title == "" ? "새로운 메시지" : title)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Button{
                        print("보내기 버튼 클릭")
                        self.vm.requestToExpert(diagnosisId: self.diagnosisResponse?.diagnosisRecordID ?? -1, title: self.title, contents: self.message)
                        self.dismiss()
                    }label:{
                        Image(systemName: "arrow.up.circle")
                            .imageScale(.large)
                    }
                    .tint(.blue)
                    .disabled(checkSendDisable)
                }.font(.system(size: 36,weight: .semibold))
                    .frame(height: 40)
                    .padding(.bottom,8)
                VStack(spacing:0){
                    Divider().frame(height: 1).background(Color.lightGray)
                    
                    HStack(spacing: 4){
                        Text("제목: ").foregroundColor(.accentColor)
                            .font(.headline)
                        TextField("질병, 작물 이름을 넣어주세요.", text: $title)
                            .frame(height: 44)
                            .foregroundColor(.black)
                    }
                    .frame(height: 44)
                    
                    Divider().frame(height: 1).background(Color.lightGray)
                    
                    if diagnosisResponse == nil {
                        self.itemSelectView.padding(.vertical,8)
                    }else{
                        self.demoItem.padding(.vertical,8)
                    }
                    Divider().frame(height: 1).background(Color.lightGray)
                }
                GeometryReader{ proxy in
                    ScrollView{
                        ZStack(alignment:.center){
                            TextEditor(text: $message).frame(minHeight: proxy.size.height,maxHeight: proxy.size.height)
                            if message.isEmpty{
                                Text("요청 메시지를 적으세요")
                            }
                        }
                        .background(.white)
                        .cornerRadius(8)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Text("취소")
                    }
                }
            }
        }
        .onAppear(){
                self.vm.getLocation(latitude: diagnosisResponse?.userLatitude ?? 0,
                                    longtitude: diagnosisResponse?.userLongitude ?? 0
                )
        }
    }
    var checkSendDisable: Bool{
        guard self.title != "" else { return true }
        guard self.diagnosisResponse != nil else {return true}
        return false
    }
}

//MARK: -- 데모 아이템
extension ExpertMailView{
    var demoItem: some View{
        HStack(spacing: 16){
            AsyncImage(url:URL(string: self.diagnosisResponse?.imagePath ?? "")){ phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                case .failure:
                    Image("logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
                @unknown default:
                    // Since the AsyncImagePhase enum isn't frozen,
                    // we need to add this currently unused fallback
                    // to handle any new cases that might be added
                    // in the future:
                    EmptyView()
                }
            }

            VStack(alignment: .leading,spacing: 4){
                HStack{
                    Text("\(Crop.koreanTable[CropType(rawValue:self.diagnosisResponse?.cropType ?? -1) ?? .none] ?? "")")
                        .font(.headline)
                    Text(Date.changeDateFormat(dateString: self.diagnosisResponse?.regDate ?? "날짜 정보 없슴")).font(.subheadline)
                    Spacer()
                }
                .padding(.top,12)
                HStack{
                    Text("병해:").font(.headline)
                    Text("\(Diagnosis.koreanTable[DiagnosisType(rawValue: self.diagnosisResponse?.diagnosisResults?[0].diseaseCode ?? -1) ?? .none] ?? "") (\(Int((self.diagnosisResponse?.diagnosisResults?[0].accuracy ?? 0) * 100))%)")
                        .font(.subheadline)
                    Spacer()
                }
                HStack{
                    Text("위치:").font(.headline)
                    Text(self.vm.location ?? "위치 정보가 없습니다.")
                        .font(.subheadline)
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(height: 100)
    }
}
//MARK: -- 작물 선택 버튼 추가 구현해야할 사항
extension ExpertMailView{
    var itemSelectView: some View{
        ZStack{
            NavigationLink(isActive: $goNextView) {
                ExpertCateMainView(isDismiss: $isDismiss, response: $diagnosisResponse)
                    .environmentObject(CM_MainVM())
            } label: {
                EmptyView()
            }
            Button{
                isDismiss = false
                goNextView = true
            }label:{
                Spacer()
                HStack(spacing: 16){
                    Image(systemName: "questionmark.circle").resizable().scaledToFit()
                    Text("진단 요청할 작물을 선택하세요")
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
            .foregroundColor(Color.accentColor)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth:8)
                    .foregroundColor(Color.accentColor)
            )
            .frame(height: 100)
        }
        .onChange(of: isDismiss) { newValue in
            if isDismiss == true{
                goNextView = false
            }
        }
        
    }
}

struct ExpertMailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpertMailView()
        }
    }
}
