//
//  DiagDiseaseModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/07/12.
//

import Foundation
enum DiagDiseaseType:Int,Hashable{
    case none = -1
    case PepperNormal = 0
    case PepperMildMotle = 1
    case PepperSpot = 2
    case StrawberryNormal = 3
    case StrawberryGrayMold = 4
    case StrawberryPowderyMildew = 5
    case LettuceNormal = 6
    case LettuceMycosis = 7
    case LettuceDownyMildew = 8
    case TomatoNormal = 9
    case TomatoLeafFungus = 10
    case TomatoYellowLeafRoll = 11
}
struct DiagDisease{
    static let koreanTable:[DiagDiseaseType:String] = [
        .PepperNormal:"정상",.TomatoNormal:"정상",.LettuceNormal:"정상",.StrawberryNormal:"정상",
        .PepperMildMotle:"고추 마일드모틀바이러스",.PepperSpot:"고추 점무늬병",
        .StrawberryGrayMold:"딸기 잿빛곰팡이병",.StrawberryPowderyMildew:"딸기 흰가루병",
        .LettuceMycosis:"상추 균핵병",.LettuceDownyMildew:"상추 노균병",
        .TomatoLeafFungus:"토마토 잎곰팡이병",.TomatoYellowLeafRoll:"토마토 황화잎말이바이러스",
        .none : "진단 오류"
    ]
}
