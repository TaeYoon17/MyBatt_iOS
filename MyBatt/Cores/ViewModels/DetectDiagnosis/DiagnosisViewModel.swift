//
//  DiagnosisViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//
import Foundation
import SwiftUI
import Combine
import Alamofire
final class DiagnosisViewModel:ObservableObject{
    static private let requestURLString: String = ""
    @Published var image: Image? = nil
    @Published var diagnosis: DiagnosisResponse? = nil
    @Published var isLoading:Bool = false
    
    private let imageInfo: String
    private let diagnosisImage: CIImage
    private var cancellable = Set<AnyCancellable>()
    init(imageInfo: String,image:CIImage){
        print("DiagnosisViewModel Init")
        self.imageInfo = imageInfo
        self.diagnosisImage = image
        self.isLoading = true
    }
    
}
