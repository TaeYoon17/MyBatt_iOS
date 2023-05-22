//
//  ImageAppearView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/22.
//

import SwiftUI

struct ImageAppearView: View {
    @EnvironmentObject var takenVM: TakenPhotoVM
    @Binding var image :Image?
    let screenWidth = UIScreen.main.bounds.width
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170)),GridItem(.adaptive(minimum: 170))
    ]
    @State private var takenView: Bool = true
    var body: some View {
        ScrollView{
            LazyVGrid(columns: adaptiveColumns,spacing: 20) {
                ForEach(takenVM.crops, id:\.self){ crop in
                    Button{
                        takenVM.selectedCropType = crop.cropType
                    }label:{
                        Label {
                            Text(crop.name)
                                .font(.title3).bold()
                        } icon: {
                            Text(crop.icon)
                                .imageScale(.large)
                                .font(.title3)
                        }
                        .frame(width: screenWidth/3)
                        .padding(.vertical,15)
                        .modifier(SelectedModifier(isSelected: crop.cropType == takenVM.selectedCropType))
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
fileprivate struct SelectedModifier: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        if isSelected{
            content
                .foregroundColor(.accentColor)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth:5).foregroundColor(.accentColor))
        }else{
            content
                .foregroundColor(
                    .black
                )
                .background(Color.white)
                .cornerRadius(15)
                .background(RoundedRectangle(cornerRadius: 15).stroke(
                    lineWidth:3
                ).foregroundColor(.black))
        }
    }
}

struct ImageAppearView_Previews: PreviewProvider {
    static var previews: some View {
        ImageAppearView(image: .constant(Image("picture_demo"))).environmentObject(TakenPhotoVM(lastCropType: .Lettuce))
    }
}
