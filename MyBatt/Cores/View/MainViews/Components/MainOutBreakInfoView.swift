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
                //                self.picker.onAppear(){
                //                    UISegmentedControl.appearance().selectedSegmentTintColor = .orange
                //                }
                self.customPicker
                self.content
            }
        }
    }
    var customPicker: some View{
        SegmentControlView(segments: OutBreakType.allCases, selected: $outBreakType, titleNormalColor: .accentColor, titleSelectedColor: .black, bgColor: bgColor, animation: .easeInOut) { segment in
            Text(segment.title)
                .foregroundColor(segment.color)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.horizontal)
                .padding(.vertical, 8)
        } background: {
            RoundedTopRectangle(radius: 10)
        }.frame(height: 30)
    }
    var content: some View{
        VStack(alignment:.leading,spacing:10){
            ForEach(datas,id:\.self){ data in
                HStack{
                    Text(data).fontWeight(.medium).font(.system(size: 14,design: .rounded))
                    if data != datas.last{
                        Spacer()
                    }
                }.padding(.leading,14)
            }
        }.padding(.vertical)
        .background(
            Rectangle().foregroundColor(.white)
                .cornerRadius(10, corners: [.bottomLeft,.bottomRight])
        )
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
