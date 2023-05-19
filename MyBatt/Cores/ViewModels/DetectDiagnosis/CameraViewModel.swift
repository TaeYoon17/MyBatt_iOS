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
import Combine
final class CameraViewModel:ObservableObject{
    let camera = Camera()
    lazy var locationService = LocationService()
    @Published var viewFinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var takenImage: Image?
    var takenCIImage: CIImage?
    var isPhothosLoaded = false
    
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isLocated: Bool = false
    @Published var address: String? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        Task{ await handleCameraPreviews() }
        Task{ await handleCameraPhotos() }
        self.addLocationSubscribers()
    }
    deinit{
        cancellable.forEach { can in
            can.cancel()
        }
    }
    private func addLocationSubscribers(){ // 의존성 주입
        let locationPublisher: Published<CLLocationCoordinate2D?>.Publisher = locationService.$coordinate
        let loadingPublisher: Published<Bool>.Publisher = locationService.$isLoading
        let addressPublisher: Published<String?>.Publisher = locationService.$address
        locationPublisher.sink{[weak self] output in
            print("locationService.$coordinate \(output)")
            self?.coordinate = output
        }.store(in: &cancellable)
        loadingPublisher.sink { [weak self] output in
            self?.isLocated = output
        }.store(in: &cancellable)
        addressPublisher.sink { [weak self] output in
            print("locationService.$address \(output)")
            self?.address = output
        }.store(in: &cancellable)
    }
    
    private func handleCameraPreviews() async{
        let imageStream = camera.previewStream.map{ $0 }
        for await image in imageStream{
            Task{ @MainActor in
                viewFinderImage = image.image!
//                print("view change!!")
            }
        }
    }
    
    private func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        for await photoData in unpackedPhotoStream{
            Task{ @MainActor in
                //thumbnailImage = photoData.thumbnailImage
                let ciimage = CIImage(data: photoData.imageData, options: [.applyOrientationProperty: true])!
                let cropCiImage = ciimage.cropImage
                print(cropCiImage.description)
                takenImage = cropCiImage.image!
                takenCIImage = cropCiImage
            }
//            savePhoto(imageData: photoData.imageData)
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
    
    //MARK: -- 사진첩 썸내일을 로드하는 함수
    func loadThumbnail() async{}
    
    //MARK: -- 사진첩을 누르면 사진 로드하기
    func loadPhotos() async{}
    
    //MARK: -- 사진 저장하기
    func savePhoto(imageData: Data) {}
    
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

extension CameraViewModel{
    
}


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
