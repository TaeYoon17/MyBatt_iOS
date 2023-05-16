//
//  DiagnosisViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//
import Foundation
import SwiftUI
import Combine
final class DiagnosisViewModel:ObservableObject{
    static private let requestURLString: String = ""
    @Published var image: Image? = nil
    @Published var diagnosis: Diagnosis? = nil
    @Published var isLoading:Bool = false
    
    private let imageInfo: String
    private let diagnosisImage: CIImage
    private let dataService: DiagnosisDataService
    private var cancellable = Set<AnyCancellable>()
    init(imageInfo: String,image:CIImage){
        print("DiagnosisViewModel Init")
        self.imageInfo = imageInfo
        self.diagnosisImage = image
        self.dataService = DiagnosisDataService(urlString: Self.requestURLString, imageInfo: imageInfo, image: image)
        self.addSubscribers()
        self.isLoading = true
    }
    private func addSubscribers(){ // 의존성 주입
        let diagnosisPublisher: Published<DiagnosisData?>.Publisher = dataService.$diagnosisData
        diagnosisPublisher.sink{[weak self] (output:DiagnosisData?) in
            print("dataService.$diagnosis called")
//            self?.image =
            self?.image = output?.iamge
            self?.diagnosis = output?.diagnosis
            self?.isLoading = false
        }.store(in: &cancellable)
    }
}
