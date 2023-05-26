//
//  MainOutBreakInfo.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/19.
//

import SwiftUI

enum OutBreakType:CaseIterable,Identifiable{
    case Advisory
    case Warning
    case Forecast
    
    var id: String{
        title
    }
    var title: String{
        switch self{
        case .Warning:
            return "주의보"
        case .Forecast:
            return "예보"
        case .Advisory:
            return "경보"
        }
    }
    var icon: String{
        switch self{
        case .Warning: return "⚠️"
        case .Advisory: return "🚫"
        case .Forecast: return "✅"
        }
    }
    var color: Color{
        switch self{
        case .Advisory: return Color.red
        case .Warning: return Color.yellow
        case .Forecast: return Color.green
        }
    }
}
struct MainOutBreakInfoView: View {
    @EnvironmentObject var userVM: UserVM
    @State private var pickerNumber = 1
    // 바인딩을 통한 값 변환
    @State private var outBreakType:OutBreakType = .Forecast
    let bgColor: Color = .white
    let datas = [
        "(토마토) 반점위조바이러스",
        "(딸기) 흰가루병"
    ]
    var body: some View {
        VStack{
            Divider().frame(minHeight: 5)
            VStack(spacing:0){
                self.customPicker
                self.content
            }
        }.onAppear(){
            userVM.fetchOutbreakList()
        }
    }
    func getListSize(type: OutBreakType)->Int{
        if let model = self.userVM.outbreakModel{
            switch type{
            case .Advisory:
                return model.watchListSize
            case .Forecast:
                return model.forecastListSize
            case .Warning:
                return model.warningListSize
            }
        }
        return 0
    }
    var customPicker: some View{
        SegmentControlView(segments: OutBreakType.allCases, selected: $outBreakType, titleNormalColor: .accentColor, titleSelectedColor: .black, bgColor: bgColor, animation: .easeInOut) { segment in
            
            (Text("\(segment.title) ")
                
                .font(.system(size: 18, weight: .semibold, design: .rounded))
             + Text("(\(self.getListSize(type: segment)))")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
            ).foregroundColor(segment.color)
            .padding(.horizontal)
            .padding(.vertical, 8)
        } background: {
            RoundedTopRectangle(radius: 10)
        }.frame(height: 30)
    }
    var content: some View{
        ScrollView(showsIndicators:false){
            switch self.outBreakType{
            case .Advisory: contentBody(datas: userVM.outbreakModel?.watchList ?? [])
            case .Forecast: contentBody(datas: userVM.outbreakModel?.forecastList ?? [])
            case .Warning: contentBody(datas: userVM.outbreakModel?.warningList ?? [])
            }
            
        }.frame(height: 100)
            .background(
                Rectangle().foregroundColor(.white)
                    .cornerRadius(10, corners: [.bottomLeft,.bottomRight])
            )
    }
    func contentBody(datas: [OutbreakItem])-> some View{
        VStack(alignment: .leading,spacing: 10){
            ForEach(datas){ data in
                HStack{
                    Text("\(data.cropName) - ")
                        .fontWeight(.semibold).font(.system(size: 15,weight: .semibold, design: .rounded))
                    +
                    Text(data.sickNameKor)
                        .fontWeight(.medium).font(.system(size: 14,design: .rounded))
                    if data.id != datas.last?.id{
                        Spacer()
                    }
                }.padding(.leading,14)
            }
            if datas.isEmpty{
                Rectangle().frame(height: 1).foregroundColor(.white)
            }
        }.padding(.vertical)

    }
}

fileprivate struct SegmentBtnView<ID:Identifiable,Content: View>:View{
    let id:ID
    @ViewBuilder var content: () -> Content
    var body: some View{
        content()
    }
}


struct MainOutBreakInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MainOutBreakInfoView().previewLayout(.sizeThatFits)
    }
}
