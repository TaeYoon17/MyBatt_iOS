//
//  CropSelectView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import SwiftUI
struct CropSelectView: View {
    @Binding var pageSheetCrop:MapSheetCrop
    let accRange: AccRange = MapSheetVM.accRange
    var body: some View {
        VStack{
            Toggle(isOn: $pageSheetCrop.isOn) {
                HStack{
                    Text(pageSheetCrop.cropKorean)
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    if pageSheetCrop.isOn{
                        Text("최소 정확도: \(Int(pageSheetCrop.accuracy))%")
                            .font(.callout)
                            .padding(.trailing,5)
                    }
                }
            }.onChange(of: pageSheetCrop.isOn) { newValue in
                print(newValue)
            }
            if pageSheetCrop.isOn{
                Slider(value: $pageSheetCrop.accuracy,in:accRange.start...accRange.end,step: 1.0) {
                    Text("최소 정확도")
                } minimumValueLabel: {
                    Text("\(Int(accRange.start))%")
                } maximumValueLabel: {
                    Text("\(Int(accRange.end))%")
                } onEditingChanged: { v in
                    if v == false{
                        print(Int(pageSheetCrop.accuracy))
                    }
                }.font(.subheadline)
            }
        }
        .padding(.horizontal)
        .padding(.vertical,8)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

struct CropSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CropSelectView(pageSheetCrop: .constant(MapSheetCrop(cropType: CropType.Lettuce.rawValue, accuracy: 85,isOn: false)))
    }
}
