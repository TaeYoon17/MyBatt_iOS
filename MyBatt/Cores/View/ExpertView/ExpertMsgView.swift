//
//  ExpertMsgView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/06.
//

import SwiftUI

struct ExpertMsgView: View {
    let width = UIScreen.main.bounds.width
    @Environment(\.dismiss) private var dismiss
//    @State private var myRequest: String? = "이게 왜 안되는 거냐고오~~"
    @State private var expertResult: String? = nil
    let diagnosis: DiagnosisResponse?
    let sendModel: ExpertSendModel?
//    @StateObject private var vm: ExpertMsgVM
    init(sendModel: ExpertSendModel?,diagnosis:DiagnosisResponse?){
        self.sendModel = sendModel
        self.diagnosis = diagnosis
    }
    var body: some View {
        NavigationView {
            VStack(spacing:0){
                HStack(alignment:.center, spacing:4){
                    Text(sendModel?.title ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.black)
                            .padding(.bottom,4)
                    Spacer()
                }.padding(.bottom)
                ScrollView {
//                    demoItem
                    MsgItemView(imgString: diagnosis?.imagePath ?? "",
                                cropName: diagnosis?.cropType ?? -1,
                                date: diagnosis?.regDate ?? "날짜 정보가 없습니다",
                                disesName: diagnosis?.diagnosisResults?[0].diseaseCode ?? -1,
                                accuracy: diagnosis?.diagnosisResults?[0].accuracy ?? 0)
                    divider
                    if let myRequest = sendModel?.contents, myRequest != ""{
                        myQuestion(myRequest: myRequest)
                        divider
                    }
                    expertResultView
                    Spacer()
                }
            }.padding()
                .navigationTitle("문의 답변")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            self.dismiss()
                        }label: {
                            Text("완료")
                        }
                    }
                }
        }
    }
    @ViewBuilder
    func makeTextBubble(_ message: String,fgColor: Color,bgColor: Color,isFlip: Bool)->some View{
        Text(message)
            .foregroundColor(fgColor)
            .font(.body.weight(.medium))
            .padding()
            .background(bgColor)
            .cornerRadius(12)
            .overlay(alignment:isFlip ? .topLeading : .topTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(isFlip ? 135 : -135))
                    .offset(x: isFlip ? -10 : 10,y:-10)
                    .foregroundColor(bgColor)
            }
            .padding(.top,8)
            .padding(.horizontal)
    }
    
}
fileprivate struct MsgItemView:View{
    let imgString: String
    let cropName: Int
    let date: String
    let disesName:Int
    let accuracy: Double
    var body:some View{
        HStack(spacing: 16){
            AsyncImage(url:URL(string: self.imgString)){ phase in
                switch phase {
                case .empty:
                    Image("logo_demo")
                        .resizable()
                        .scaledToFit()
                        .background(Color.ambientColor)
                        .cornerRadius(8)
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
                    Text("\(Crop.koreanTable[CropType(rawValue: cropName) ?? .none] ?? "")")
                        .font(.headline)
                    Text("\(Date.changeDateFormat(dateString: date))")
                        .font(.subheadline)
                    Spacer()
                }
                HStack(alignment:.top){
                    Text("병해:").font(.headline)
                    Text("\(Diagnosis.koreanTable[DiagnosisType(rawValue: disesName) ?? .none] ?? "") \(Int(accuracy * 100))%")
                        .font(.subheadline)
                    Spacer()
                }
                Spacer()
            }
//            .overlay(alignment:.topTrailing){
//                Image(systemName: "chevron.right")
//                    .padding(.top,8)
//            }
        }
        .padding(.vertical,12)
        .background(Color.white)
        .frame(height: 120)
    }
}
extension ExpertMsgView{
    //MARK: -- Divider 설정
    var divider: some View{
        Divider().frame(height: 2)
            .background(Color.lightGray)
            .padding(.vertical,4)
    }
    func myQuestion(myRequest: String)->some View{
        VStack(alignment: .leading,spacing:8){
            Text("내 질문").font(.title2).bold()
            HStack{
                HStack{
                    makeTextBubble(myRequest,fgColor: .black, bgColor: .lightGray, isFlip: true)
                    Spacer()
                }
                .frame(minWidth: 0,maxWidth: width * 0.8)
                Spacer()
            }
        }
    }
    var expertResultView: some View{
        VStack(alignment: .trailing,spacing:8){
            Text("전문가 답변").font(.title2).bold()
            HStack{
                Spacer()
                HStack{
                    Spacer()
                    if let result = expertResult,result != ""{
                        makeTextBubble("이건 너가 잘 못 찍어서 잘 모르겠는뒈~",fgColor: .black ,bgColor: .ambientColor, isFlip: false)
                    }else{
                        makeTextBubble("아직 답변이 오지 않았어요",fgColor: .white ,bgColor: .red, isFlip: false)
                    }
                }
                .frame(minWidth: 0,maxWidth: width * 0.8)
            }
        }
    }
}

//struct ExpertMsgView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//            ExpertMsgView()
//        
//    }
//}
