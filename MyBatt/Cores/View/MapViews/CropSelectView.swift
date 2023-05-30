//
//  CropSelectView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/16.
//

import SwiftUI
struct CropSelectView: View {
    @Binding var pageSheetCrop:MapSheetCrop
    @Binding var myDiagnosis: [DiagnosisType:Int]?
    @State private var acc: Double = 50
    let accRange: AccRange = MapSheetVM.accRange
    var body: some View {
        VStack{
            Toggle(isOn: $pageSheetCrop.isOn) {
                VStack{
                    HStack{
                        Text(pageSheetCrop.cropKorean)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(pageSheetCrop.cropColor)
                        Spacer()
                        if pageSheetCrop.isOn{
                            Text("최소 정확도: \(Int(acc))%")
                                .font(.callout)
                                .padding(.trailing,5)
                        }
                    }
                    
                }
            }.onChange(of: pageSheetCrop.isOn) { newValue in
//                print(newValue)
            }
            if pageSheetCrop.isOn{
                VStack{
                    Slider(value: $acc,in:accRange.start...accRange.end,step: 5.0) {
                        Text("최소 정확도")
                    } minimumValueLabel: {
                        Text("\(Int(accRange.start))%")
                    } maximumValueLabel: {
                        Text("\(Int(accRange.end))%")
                    } onEditingChanged: { v in
                        if v == false{
                            print("onEditingChanged: \(Int(acc))")
                            pageSheetCrop.accuracy = acc
                        }
                    }.font(.subheadline)
                    if let myDiagnosis = myDiagnosis{
                        VStack(spacing:4){
                            ForEach(Array(myDiagnosis.keys.sorted(by: { lhs, rhs in
                                lhs.rawValue < rhs.rawValue
                            })),id:\.self){ key in
                                HStack{
                                    (
                                        Text("\(Diagnosis.koreanTable[key] ?? "") 계수: ")
                                        .font(.footnote).fontWeight(.semibold)
                                    + Text("\(myDiagnosis[key] ?? 0)").font(.footnote)
                                     )
                                    Spacer()
                                }
                            }
                        }
                    }
                }
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
        CropSelectView(pageSheetCrop: .constant(MapSheetCrop(cropType: CropType.Lettuce.rawValue, accuracy: 85,isOn: false)), myDiagnosis: .constant([:]))
    }
}
