//
//  TakenPhotoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/03.
//

import SwiftUI
import Foundation

struct CropTypePhoto:Identifiable,Hashable{
    var id = UUID()
    let icon: String
    let name: String
}
struct TakenPhotoView: View {
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var cameraModel: CameraViewModel
    @EnvironmentObject var appManager: AppManager
    //    @Binding var image: Image?
    @Binding var takenView: Bool
    //    @Binding var cameraView: Bool
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170)),GridItem(.adaptive(minimum: 170))
    ]
    let crops =
    [CropTypePhoto(icon:"🍓",name:"딸기"),CropTypePhoto(icon:"🥬",name:"상추"),CropTypePhoto(icon:"🍅",name:"토마토"),CropTypePhoto(icon:"🌶️",name:"고추")]
    var body: some View {
         if let image = cameraModel.takenImage{
                imageAppearView(image: image)
//                 .onDisappear(){
//                    cameraModel.takenImage = nil
//                }
         }else{
             ProgressView()
         }
//        imageAppearView(image: Image("picture_demo"))
    }
    func imageAppearView(image:Image)-> some View{
        VStack{
            VStack(spacing:10){
                image.resizable().scaledToFill()
                ScrollView{
                    LazyVGrid(columns: adaptiveColumns,spacing: 15) {
                        ForEach(crops, id:\.self){ crop in
                            if crop.name == "고추"{
                                Label {
                                    Text(crop.name)
                                        .font(.title3)
                                } icon: {
                                    Text(crop.icon)
                                        .imageScale(.large)
                                        .font(.title3)
                                }
                                .frame(width: screenWidth/3)
                                .padding(.vertical,10)
                                .foregroundColor(.accentColor)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth:5).foregroundColor(.accentColor))
                            }else{
                                Label {
                                    Text(crop.name)
                                        .font(.title3)
                                } icon: {
                                    Text(crop.icon)
                                        .imageScale(.large)
                                        .font(.title3)
                                }
                                .frame(width: screenWidth/3)
                                .padding(.vertical,10)
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
                    .padding(.vertical)
                }
            }
            Spacer()
            TakenBtnView().padding(.vertical)
        }
    }
}

struct TakenPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakenPhotoView(takenView: .constant(true))
            .environmentObject(CameraViewModel())
            .environmentObject(AppManager())
    }
}
