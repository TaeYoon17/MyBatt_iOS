//
//  DiagnosisDataService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/10.
//

import Foundation
import SwiftUI
import Combine
struct Diagnosis:Codable{
    let responseCode: Int
    let cropType: Int
    let regData: String
    let diagnosisItems:[DiagnosisItem]
    let imagePath: String
}
struct DiagnosisItem: Codable{
    let diseaseCode: String
    let accuracy: Double
    let boxX1:Double
    let boxX2: Double
    let boxY1:Double
    let boxY2:Double
}
typealias DiagnosisData = (diagnosis:Diagnosis,iamge:Image)
final class DiagnosisDataService{
    @Published var diagnosisData: DiagnosisData?
//    @Published var diagnosisImage: Image? = nil
    var diagnosisSubscription: AnyCancellable?
    let boundary = UUID()
    init(urlString: String,imageInfo: String,image:CIImage){
        getDiagnosis(urlString: urlString, imageInfo: imageInfo, image: image)
    }
    private func getDiagnosis(urlString: String,imageInfo: String,image:CIImage){
        guard let url = URL(string: urlString) else {
            print("There is no ulr string")
            return
        }
        let urlRequest = getURLRequest(url: url, imageInfo: imageInfo, image: image)
        diagnosisSubscription = NetworkingManager.upload(request: urlRequest)
            .tryMap({ (data) -> Diagnosis in
                guard let diagnosis: Diagnosis = try? JSONDecoder().decode(Diagnosis.self, from: data) else{
                    throw fatalError("Diagnosis Wrong")
                }
                return diagnosis
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:)) { [weak self] (diagnosis: Diagnosis) in
                print("getCoinImage sinked")
                self?.diagnosisData = (diagnosis,image.image!)
                self?.diagnosisSubscription?.cancel()
        }
    }
    private func getURLRequest(url: URL,imageInfo: String,image:CIImage)->URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary= \(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        guard let dataImage = UIImage(ciImage: image,scale: 1,orientation: .up)
            .jpegData(compressionQuality: 1) else { return request }
        let requestBody = getRequestBody(imageInfo: imageInfo, image: dataImage)
        request.httpBody = requestBody
        return request
    }
    private func getRequestBody(imageInfo: String,image: Data)->Data{
        var requestBody = Data()
        // Add any additional form fields
        let diagnosis = """
    {"userId":10, "userLatitue":"1.1", "userLongitude":"2.2", "regDate":"2023-02-20T11:22:33.000000", "cropType":"1"}
    """
//        print(String(decoding: diagnosisData.jsonEncoding(),as: UTF8.self))
        requestBody.append("--\(self.boundary)\r\n".data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"requestInput\"\r\n\r\n".data(using: .utf8)!)
        requestBody.append("\(diagnosis)\r\n".data(using: .utf8)!)
        requestBody.append("--\(self.boundary)\r\n".data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image_png\"\r\n".data(using: .utf8)!)
        requestBody.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        requestBody.append(image)
        requestBody.append("\r\n".data(using: .utf8)!)
        // Add the closing boundary
        requestBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return requestBody
    }
}
