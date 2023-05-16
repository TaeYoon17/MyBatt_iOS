//
//  TakenBtnView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import SwiftUI

struct TakenBtnView: View {
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
            //            GeometryReader{proxy in
            HStack{
                Spacer()
                Button{ }label:{
                    Label {
                        Text("다시 촬영하기").fontWeight(.bold)
                    } icon: {
                        Image(systemName: "arrowshape.turn.up.backward")
                    }.font(.headline)
                        .frame(width:
                                screenWidth/3
                               //                               100
                        )
                        .padding()
                        .foregroundColor(.red)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 5)
                                .foregroundColor(.red)
                        )
                }
                Spacer()
                Button{ }label:{
                    Label {
                        Text("전송하기").fontWeight(.bold)
                    } icon: {
                        Image(systemName: "paperplane")
                    }.font(.headline)
                        .frame(width:screenWidth/3)
                        .padding()
                        .foregroundColor(.accentColor)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 5)
                        )
                }
                Spacer()
            }
            //            }
            //            .edgesIgnoringSafeArea(.all)
            
            //            .frame(width: proxy.size.width,
            //                    height: (proxy.size.height-proxy.size.width) / 2)
            //            .offset(y: proxy.size.height / 2)
            //            .background(Color.lightGray.opacity)
            //        }
        
    }
}


struct TakenBtnView_Previews: PreviewProvider {
    static var previews: some View {
        TakenBtnView()
    }
}

