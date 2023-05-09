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
final class CameraModel:ObservableObject{
    let camera = Camera()
    
    @Published var viewFinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var takenImage: Image?
    @Published var viewFinderUIImage: UIImage?
    var takenUIImage: UIImage?
    var takenCIImage: CIImage?
    
    var isPhothosLoaded = false
    init(){
        Task{ await handleCameraPreviews() }
        Task{ await handleCameraPhotos() }
    }
    func handleCameraPreviews() async{
        //        : AsyncMapSequence<AsyncStream<CIImage>,Image?>
        let imageStream = camera.previewStream
            .map{
                $0
            }
        //        { (it:CIImage)->Image? in it.image }
        for await image in imageStream{
            Task{ @MainActor in
                viewFinderImage = image.image!
                takenCIImage = image
            }
        }
    }
    
    //viewFinderImage = Image(uiImage: image)
    //// 실제 뷰 파인더 뷰에 이미지를 투영시킨다
    //let width = image.size.width
    //let height = image.size.height
    //let croppedRect = CGRect(x:0,y:0,width: width, height:width)
    ////                print(croppedRect)
    //if let croppedCGImage = image.cgImage?.cropping(to: croppedRect){
    //    let croppedImage = UIImage(cgImage: croppedCGImage,scale: 1,orientation: .right)
    //    viewFinderUIImage = croppedImage
    ////                    viewFinderImage = Image(uiImage: croppedImage)
    
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        for await photoData in unpackedPhotoStream{
            Task{ @MainActor in
                //thumbnailImage = photoData.thumbnailImage
                takenUIImage = UIImage(data: photoData.imageData)
                let ciimage = CIImage(data: photoData.imageData,
                                      options: [.applyOrientationProperty: true])!
                let width = ciimage.extent.width
                let cropCIImage = ciimage.cropped(to: CGRect(x: 0, y: 0, width: width,height:width))
                takenImage = cropCIImage.image!
            }
            savePhoto(imageData: photoData.imageData)
        }
    }
    // Device Camera에서 가져온 AVCapturePhoto를 Image로 바꾸기
    fileprivate func unpackPhoto(_ photo:AVCapturePhoto)-> PhotoData?{
        // AVCapturePhoto 타입을 Data 타입으로 바꾼다.
        print(photo.description)
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

// MARK: -- AVCaputureVideo 데이터 형식에서 추출한 사용할 데이터 들
fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

// 코어 이미지에서 SwiftUI용 이미지 뷰로 바꿔주는 getter 프로퍼티
fileprivate extension CIImage{
    var image: Image?{
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {return nil}
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
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
