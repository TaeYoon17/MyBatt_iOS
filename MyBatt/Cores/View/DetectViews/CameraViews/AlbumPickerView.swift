//
//  LoadPhotoView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/22.
//

import SwiftUI
enum SelectStep:String,Identifiable{
    case Pick,Crop
    var id: String { rawValue }
}
struct AlbumPickerView: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var userVM: UserVM
    @StateObject var takenVM: TakenPhotoVM = TakenPhotoVM(lastCropType: .Lettuce)
    @StateObject var vm: AlbumPickerVM = AlbumPickerVM()
    @State private var uiimage:UIImage? = nil
    @State private var image : Image? = Image("")
    @State private var selectStep: SelectStep?
    var body: some View {
        ZStack{
            VStack{
                VStack(spacing:10){
                    if let image = image{
                        image.resizable()
                            .scaledToFill()
                    }
                    ImageAppearView(image: $image).environmentObject(takenVM)
                }
                Spacer()
                HStack{
                    Spacer()
                    ImageAppeaerBtnView(btnAction:{
                        self.selectStep = .Pick
                    },labelText: "다시 선택하기", iconName: "photo.on.rectangle.angled",bgColor:
                        .accentColor
                    )
                    Spacer()
                    ImageAppeaerBtnView(btnAction:{
                        print("AlbumPickerView Request 실행")
                        vm.fetchToRequestImage(cropType: takenVM.selectedCropType, completion: userVM.requestImage(cropType:geo:image:))
//                        userVM.requestImage(cropType: takenVM.selectedCropType, geo: .init(latitude: 0, longitude: 0), image: uiimage!)
                        appManager.goRootView()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                            appManager.isDiagnosisActive = true
                        }
                        appManager.isDiagnosisActive = true
                    },labelText: "전송하기", iconName:"paperplane", bgColor: .blue)
                    Spacer()
                }
                
            }
            
        }
        .onAppear(){
            selectStep = .Pick
        }
        .onDisappear(){
            appManager.isAlbumActive = false
            appManager.isTabbarHidden = false
            selectStep = .Pick
        }
        .sheet(item: $selectStep) { sheet in
            switch sheet{
            case .Crop: CropperView(image: $image,uiimage: $uiimage)
                    .environmentObject(vm)
                    .overlay(alignment: .top, content: {
                        Text("이미지를 확대, 축소, 이동해 자르세요")
                            .font(.footnote)
                            .foregroundColor(.white).padding(.top,14)
                    })
                    .onDisappear(){
                        selectStep = nil
                        userVM.diagnosisImage = self.image
                        vm.saveImageToAlbum()
                    }
                    .edgesIgnoringSafeArea(.bottom)
            case .Pick:
                PHPickerView(uiimage: $uiimage)
                    .edgesIgnoringSafeArea(.bottom)
                    .onDisappear(){
                        if uiimage != nil{
                            selectStep = .Crop
                        }else{
                            appManager.goRootView()
                        }
                }
            }
        }
        
    }
}

struct AlbumPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPickerView()
    }
}
