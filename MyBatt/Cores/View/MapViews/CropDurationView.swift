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
                    print(newValue)
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
