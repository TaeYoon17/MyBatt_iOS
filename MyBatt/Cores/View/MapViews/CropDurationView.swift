//
//  CropDurationView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import SwiftUI

struct CropDurationView: View {
    @EnvironmentObject var vm: MapSheetVM
    
    private var today: (Int,Int,Int) {
        let date = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let year = components.year,
           let month = components.month,
           let day = components.day {
            return (year,month,day)
        }else{
            return (0,0,0)
        }
    }
    var body: some View {
        GroupBox{
            // Body
            if vm.durationType == .custom{
                DatePicker(selection: $vm.selectDate,
                           in:vm.dateRange, displayedComponents: .date,
                           label: {
                    Text("오늘: ").fontWeight(.semibold) + Text("\(String(today.0))년 \(today.1)월 \(today.2)일")
                })
                .onChange(of: vm.selectDate) { newValue in
                }
            }
        } label:{
            labelView
        }.bgColor(.white)
    }
    private var labelView: some View{
        HStack(alignment: .center){
            Text("검색 기간")
            Spacer()
            Picker("설정", selection:$vm.durationType) {
                ForEach(DurationType.allCases,id:\.self) { duration in
                    Text(duration.rawValue)
                }
            }
            .pickerStyle(.menu)
            .background(.white)
            .onChange(of: vm.durationType) { newValue in
                //여기서 네트워킹
                let currentDate = Date()
                switch newValue{
                case .custom: break
                case .day:
                    let oneDay: TimeInterval = 24 * 60 * 60
                    vm.selectDate = currentDate.addingTimeInterval(-oneDay)
                case .fortnight:
                    let halfMonth: TimeInterval = 60 * 60 * 24 * 15
                    vm.selectDate = currentDate.addingTimeInterval(-halfMonth)
                case .month:
                    let calendar = Calendar.current // 현재 사용되는 달력
                    var dateComponents = DateComponents()
                    dateComponents.month = -1
                    vm.selectDate = calendar.date(byAdding: dateComponents, to: currentDate)!
                case .quarter:
                    let calendar = Calendar.current // 현재 사용되는 달력
                    var dateComponents = DateComponents()
                    dateComponents.month = -3
                    vm.selectDate = calendar.date(byAdding: dateComponents, to: currentDate)!
                case .week:
                    let week: TimeInterval = 60 * 60 * 24 * 7
                    vm.selectDate = currentDate.addingTimeInterval(-week)
                }
                print(newValue.rawValue)
            }
        }
    }
}

struct CropDurationView_Previews: PreviewProvider {
    static var previews: some View {
        CropDurationView().environmentObject(MapSheetVM())
    }
}
