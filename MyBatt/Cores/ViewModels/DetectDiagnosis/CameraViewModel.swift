//
//  CameraMoel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/01.
//

import Foundation
import SwiftUI
import os.log
import AVFoundation
import CoreLocation
//import PhotoKit
import PhotosUI
import Photos
import ImageIO
import UIKit
import Combine
final class CameraViewModel:NSObject,ObservableObject{
    let camera = Camera()
    let locationService = LocationService.shared
    @Published var viewFinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var takenImage: Image?
    var takenCIImage: CIImage?
    var isPhothosLoaded = false
    var localIdentifier: String? = nil
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isLocated: Bool = false
    @Published var address: String? = nil
    private var cancellable = Set<AnyCancellable>()
    
    override init(){
        super.init()
        Task{[weak self] in await self?.handleCameraPreviews() }
        Task{[weak self] in await self?.handleCameraPhotos() }
        self.addLocationSubscribers()
    }
    deinit{
        cancellable.forEach { can in
            can.cancel()
        }
        print("CameraViewModel 사라짐!!")
    }
    private func addLocationSubscribers(){ // 의존성 주입
        let loadingPublisher: Published<Bool>.Publisher = locationService.$isLoading
        locationService.addressPasthrough.sink { [weak self] output in
            self?.address = output
        }.store(in: &cancellable)
        locationService.locationPassthrough.sink{[weak self] output in
            print("locationService.$coordinate \(output)")
            self?.coordinate = CLLocationCoordinate2D(geo: output)
            self?.locationService.requestAddress(geo: output) // 출력된 결과로 다시 한국어 주소를 요청해야한다.
        }.store(in: &cancellable)
        loadingPublisher.sink { [weak self] output in
            self?.isLocated = output
        }.store(in: &cancellable)
    }
    
    private func handleCameraPreviews() async{
        let imageStream = camera.previewStream.compactMap{ $0 }
        Task{[weak self] in
            for await image in imageStream{
                Task{ @MainActor [weak self, image] in
                    self?.viewFinderImage = image.image!
                }
            }
        }
    }
    
    private func handleCameraPhotos() async {
//      PhotoStream도 weak self로 참조 낮추어야한다... 왜징
        let unpackedPhotoStream = camera.photoStream
            .compactMap {[weak self] in self?.unpackPhoto($0) }
        Task{[weak self] in
            for await photoData in unpackedPhotoStream{
                Task{ @MainActor [weak self] in
                    //thumbnailImage = photoData.thumbnailImage
                    let ciimage = CIImage(data: photoData.imageData, options: [.applyOrientationProperty: true])!
                    let cropCiImage = ciimage.cropImage
                    print(cropCiImage.description)
                    self?.takenImage = cropCiImage.image!
                    self?.takenCIImage = cropCiImage
                }
                //            savePhoto(imageData: photoData.imageData)
            }
        }
    }
    // Device Camera에서 가져온 AVCapturePhoto를 Image로 바꾸기
    fileprivate func unpackPhoto(_ photo:AVCapturePhoto)-> PhotoData?{
        // AVCapturePhoto 타입을 Data 타입으로 바꾼다.
        //        print(photo.description)
        guard let imageData: Data = photo.fileDataRepresentation() else { return nil }
        
        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        // cgImageOrientation으로 UIView Image의 Orientation을 설정한다.
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
    //MARK: -- 사진 저장하기
    func saveImageToAlbum() {
        // 이미지 저장을 요청하기 전에 이미지 이름을 설정합니다.
        guard let ciimage = self.takenCIImage else {
            print("CIImage 없음!!")
            return
        }
        PHPhotoLibrary.requestAuthorization { (state) in
            print(state)
        }
       print("savePhoto 실행!!")
        //이미지 저장 타입(jpeg)을 줘야한다!!
        let image:UIImage = UIImage(data:UIImage(ciImage: ciimage).jpegData(compressionQuality: 1)!)!
        var savedAssetID: String?
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
            request.location = CLLocation()
            savedAssetID = request.placeholderForCreatedAsset?.localIdentifier
            self.localIdentifier = savedAssetID!
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
    
    var currentZoomFactor: CGFloat = 2.0
    var lastScale: CGFloat = 2.0
    func zoom(factor: CGFloat){
        let delta = factor / lastScale
        lastScale = factor
        let newScale = min(max(currentZoomFactor * delta,2),5)
        camera.zoom(newScale)
        currentZoomFactor = newScale
    }
    func zoomInitialize(){
        lastScale = 2.0
    }
}

//MARK: -- FetchImage 저장 된 곳
extension CameraViewModel{
    func fetchToRequestImage(cropType: DiagCropType,completion:@escaping ((DiagCropType,CLLocationCoordinate2D,UIImage)->Void)){
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier!], options: nil)
        let size = 1280
//        let size = 360
        print("가져올 데이터 사이즈 \(size)")
        if let asset = fetchResult.firstObject {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: size, height: size),
                                                  contentMode: .aspectFit, options: nil) {[weak self] (image, info) in
                // 가져온 이미지를 사용
                if let image = image {
                    // 이미지 사용 코드 작성
//                    returnImage = image
//                    semaphore.signal()
                    print("이미지 전송 시작")
                    completion(cropType,self?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),image)
                }
            }
        }

    }
}


//MARK: -- Thumbnail 관련
extension CameraViewModel{ }


// MARK: -- AVCaputureVideo 데이터 형식에서 추출한 사용할 데이터 들
fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension Image.Orientation {
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
