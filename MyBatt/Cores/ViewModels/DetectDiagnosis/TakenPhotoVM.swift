//
//  TakenViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/17.
//

import Foundation

final class TakenPhotoVM:ObservableObject{
    let crops:[CropSelect] = DiagCropType.allCases.compactMap{ cropType in
        guard let korean = DiagCrop.koreanTable[cropType],let icon = DiagCrop.iconTable[cropType] else { return nil }
        return CropSelect(cropType: cropType, name: korean, icon: icon)
    }
    @Published var selectedCropType: DiagCropType = .Lettuce
    struct CropSelect:Identifiable,Hashable{
        var id = UUID()
        let cropType:DiagCropType
        let name:String
        let icon:String
    }
    init(lastCropType: DiagCropType) {
        selectedCropType = lastCropType
    }
}
