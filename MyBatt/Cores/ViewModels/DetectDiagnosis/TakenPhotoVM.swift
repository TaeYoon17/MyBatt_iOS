//
//  TakenViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/17.
//

import Foundation

final class TakenPhotoVM:ObservableObject{
    let crops:[CropSelect] = CropType.allCases.compactMap{ cropType in
        guard let korean = Crop.koreanTable[cropType],let icon = Crop.iconTable[cropType] else { return nil }
        return CropSelect(cropType: cropType, name: korean, icon: icon)
    }
    @Published var selectedCropType: CropType = .Lettuce
    struct CropSelect:Identifiable,Hashable{
        var id = UUID()
        let cropType:CropType
        let name:String
        let icon:String
    }
    init(lastCropType: CropType) {
        selectedCropType = lastCropType
    }
}
