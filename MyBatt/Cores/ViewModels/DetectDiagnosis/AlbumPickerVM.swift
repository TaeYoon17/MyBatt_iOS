//
//  AlbumPickerVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/31.
//

import Foundation
import SwiftUI
import Photos
final class AlbumPickerVM:ObservableObject{
    @Published var uiimage:UIImage? = nil
    var localIdentifier: String?
    deinit{
        print("AlbumPickerVM 사라짐!!")
    }
    func saveImageToAlbum() {
        // 이미지 저장을 요청하기 전에 이미지 이름을 설정합니다.
        PHPhotoLibrary.requestAuthorization { (state) in
            print(state)
        }
       print("savePhoto 실행!!")
        //이미지 저장 타입(jpeg)을 줘야한다!!
        guard let image:UIImage = self.uiimage else { return }
        var savedAssetID: String?
        PHPhotoLibrary.shared().performChanges({[weak self] in
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
            request.location = CLLocation()
            savedAssetID = request.placeholderForCreatedAsset?.localIdentifier
            self?.localIdentifier = savedAssetID!
        }, completionHandler: { success, error in
            if success, let assetID = savedAssetID {
                // 이미지가 성공적으로 저장되었을 때의 처리
                print("Image saved with name: ")
            } else {
                // 이미지 저장 중에 오류가 발생했을 때의 처리
                if let error = error {
                    print("Error saving image: \(error.localizedDescription)")
                } else {
                    print("Image save operation was not successful.")
                }
            }
        })
    }
    
    func fetchToRequestImage(cropType: DiagCropType,completion:@escaping ((DiagCropType,CLLocationCoordinate2D,UIImage)->Void)){
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier!], options: nil)
        let size = 1280
//        let size = 360
        print("가져올 데이터 사이즈 \(size)")
        if let asset = fetchResult.firstObject {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: size, height: size), contentMode: .aspectFit, options: nil) { (image, info) in
                // 가져온 이미지를 사용
                if let image = image {
                    // 이미지 사용 코드 작성
                    print("이미지 전송 시작")
                    completion(cropType,.init(latitude: 0, longitude: 0),image)
                }
            }
        }

    }
}
