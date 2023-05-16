//
//  MapSheetView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/15.
//

import SwiftUI

struct MapSheetView: View {
    @State var isCustom: Bool = false
    @State var selectionIdx:Int = 2 {
        didSet {
            print("isChanged")
        }
    }
    @State var number:Int = 1
    @State var data:Date = Date()
    @State var isPresented = false
    @State var isPepper = false
    @State var slider = 76.0
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing: 15){
                HStack{
                    TextField("구리시 인창동", text:.constant("") ).padding(.vertical, 10)
                        .padding(.horizontal).background {
                            RoundedRectangle (cornerRadius: 10,style: .continuous)
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.gray)
                    Button{}label: {
                        Image(systemName: "location")
                    }.buttonBorderShape(.roundedRectangle)
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                }
                GroupBox {
                    VStack{
                        Toggle(isOn: $isPepper) {
                            HStack{
                                Text("고추")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Spacer()
                                if isPepper{
                                    Text("최소 정확도: \(Int(slider))%")
                                        .font(.callout)
                                        .padding(.trailing,5)
                                }
                            }
                        }
                        if isPepper{
                            Slider(value: $slider,in:80.0...90.0) {
                                Text("최소 정확도")
                            } minimumValueLabel: {
                                Text("80%")
                            } maximumValueLabel: {
                                Text("90%")
                            }.padding(.leading)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .background(.ultraThinMaterial)
                    VStack{
                        Toggle(isOn: $isPepper) {
                            HStack{
                                Text("고추")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Spacer()
                                if isPepper{
                                    Text("최소 정확도: \(Int(slider))%")
                                        .font(.callout)
                                        .padding(.trailing,5)
                                }
                            }
                        }
                        if isPepper{
                            Slider(value: $slider,in:80.0...90.0) {
                                Text("최소 정확도")
                            } minimumValueLabel: {
                                Text("80%")
                            } maximumValueLabel: {
                                Text("90%")
                            }.padding(.leading)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .background(.ultraThinMaterial)
                    VStack{
                        Toggle(isOn: $isPepper) {
                            HStack{
                                Text("고추")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Spacer()
                                if isPepper{
                                    Text("최소 정확도: \(Int(slider))%")
                                        .font(.callout)
                                        .padding(.trailing,5)
                                }
                            }
                        }
                        if isPepper{
                            Slider(value: $slider,in:80.0...90.0) {
                                Text("최소 정확도")
                            } minimumValueLabel: {
                                Text("80%")
                            } maximumValueLabel: {
                                Text("90%")
                            }.padding(.leading)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .background(.ultraThinMaterial)
                } label: {
                    Text("작물 이름")
                }
                //                .groupBoxStyle(CustomGroupBoxStyle())
                GroupBox{
                    if selectionIdx == 4{
                        DatePicker(selection: $data,
                                   label: { Text("Date")
                        }
                        )
                    }
                } label:{
                    HStack(alignment: .center){
                        Text("검색 기간")
                        Spacer()
                        Picker("설정", selection:$selectionIdx) {
                            ForEach(1...4,id:\.self) { idx in
                                if(idx == 4 ){
                                    Text("자체 설정")
                                }else{
                                    Text("\(idx)")
                                }
                            }
                        }
                        .id(selectionIdx)
                        .pickerStyle(.menu)
                        .background(.white)
                    }
                }
                //                .groupBoxStyle(CustomGroupBoxStyle())
            }.padding()
        }
        .background(.thickMaterial)
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView()
    }
}
