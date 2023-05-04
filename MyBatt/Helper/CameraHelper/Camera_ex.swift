//
//  Camera.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/01.
//
/*
import AVFoundation
import UIKit
import CoreImage
import os.log

class Camera: NSObject{
    // MARK: -- 변수!
    private let captureSession = AVCaptureSession() // 사진 촬영 진행을 관리하는 인스턴스
    private var isCaptureSessionConfigured: Bool = false // 사진 촬영을 진행할 구성이 되었는가
    private var deviceInput: AVCaptureDeviceInput? // 실제 촬영을 위한 Output
    private var photoOutput: AVCapturePhotoOutput? // 사진 프리뷰를 위한 Output
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue : DispatchQueue!
    
    // 디바이스 가져오기
    private var captureDevice:AVCaptureDevice?{
        didSet{
            guard let captureDevice = captureDevice else { return }
            print("Using capture device: \(captureDevice.localizedName)")
            sessionQueue.async {
                //                이거 알아보기
                self.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }
    var isRunning: Bool{
        captureSession.isRunning
    }
    private var deviceOrientation: UIDeviceOrientation{
        var orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.unknown{
            orientation = .portrait
        }
        return orientation
    }
    //MARK: --  Getter 파라미터
    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices
            .filter( { $0.isConnected } ) // 연결이 된 기기
            .filter( { !$0.isSuspended } )// 사용이 멈추지 않은 것
    }
    
    private var allCaputreDevice:[AVCaptureDevice]{
        // AVCaptureDevice에서 사용할 기기를 찾아서 가져오는 메서드: Discovery Session
        // deviceTypes: 사용할 기기의 타입을 가져오는 enum data
        // mediaType: 사용할 AV의 media type
        // position: 후면 카메라만 쓸 것인지, 전면 카메라만 쓸 것인지, 전부 다 쓸 것인지 설정
        AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInDualWideCamera], mediaType: .video, position: .unspecified).devices
    }
    private var backCaptureDevices:[AVCaptureDevice]{
        allCaputreDevice.filter{$0.position == .back}
    }
    private var frontCaptureDevices:[AVCaptureDevice]{
        allCaputreDevice.filter{$0.position == .front}
    }
    var isUsingFrontCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return frontCaptureDevices.contains(captureDevice)
    }
    private var captureDevices: [AVCaptureDevice] {
        // 카메라 디바이스들 가져오기
        var devices = [AVCaptureDevice]()
#if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
        // 특정 OS만 진행되는 실행
        devices += allCaptureDevices
        // devices = [여러 기계들 타입들]
#else
        // 일반적인 OS에서 진행됨 - 하나의 후면 카메라만 가져오는 것
        if let backDevice = backCaptureDevices.first {
            devices += [backDevice]
        }
        // 일반적인 OS에서 진행됨 - 하나의 전면 카메라만 가져오는 것
        if let frontDevice = frontCaptureDevices.first {
            devices += [frontDevice]
        }
        // devices = [후면카메라 하나, 전면 카메라 하나]
#endif
        return devices
    }
    override init() {
        super.init()
        initialize()
    }
    func initialize(){
        sessionQueue = DispatchQueue(label: "session queue")
        self.captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
        // 현재 기기의 방향을 알려주는 Notification을 생성하도록 하는 UIDevice의 메서드
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        // 기기 방향 변경 Notification을 받으면 실행할 selector를 바인딩해주는 obbserver
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc func updateForDeviceOrientation(){
        // 기기 방향 변화 발생시 뭘 하고 싶으면 로직 추가하기
    }
    // MARK: -- PhotoStream 설정
    // 사진을 가져오는 제너레이터이다.
    lazy var photoStream: AsyncStream<AVCapturePhoto> = {
        AsyncStream { continuation in
            // 스트림이 할 작업
            addToPhotoStream = { photo in
                // 사진을 가져와서 다음 continuation에 넘긴다.
                continuation.yield(photo)
            }
        }
    }()
    var addToPhotoStream:((AVCapturePhoto)->Void)?
    
    // MARK: -- PrevieStream 설정
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream{ continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    var isPreviewPaused = false
    var addToPreviewStream:((CIImage)->Void)?
//MARK: -- 일단 붙여넣기 함
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }
        
        if let deviceInput = deviceInputFor(device: captureDevice) {
            if !captureSession.inputs.contains(deviceInput), captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        
        updateVideoOutputConnection()
    }
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let error {
            print("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    func switchCaptureDevice() {
        if let captureDevice = captureDevice, let index = availableCaptureDevices.firstIndex(of: captureDevice) {
            let nextIndex = (index + 1) % availableCaptureDevices.count
            self.captureDevice = availableCaptureDevices[nextIndex]
        } else {
            self.captureDevice = AVCaptureDevice.default(for: .video)
        }
    }
}
//MARK: -- 카메라 기능 실행 시작 메서드 관련 설정
extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate{
    func start() async{
        // 카메라 접근 허가 상태 받기 false면 시작 안함
        let authorized = await checkAuthorization()
        guard authorized else{
            print("Camera access was not authorized.")
            return
        }
        
        if isCaptureSessionConfigured { // 캡쳐 Session이 구성(준비)되었는지 확인
            if !captureSession.isRunning{ // 만약 캡쳐 Session이 동작 중이 아니면 세션용 큐에 실행시킨다.
                sessionQueue.async { [self] in
                    // 캡쳐가 계속 실행된다.
                    print("isCaptureSessionConfigured startRunning")
                    self.captureSession.startRunning()
                }
            }
            return
        }
        
        sessionQueue.async { [self] in
            self.configureCaptureSession{ success in
                guard success else {return}
                print("startRunning")
                self.captureSession.startRunning()
            }
        }
    }
    private func checkAuthorization() async -> Bool{
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized: // 이미 승인된 상태
            print("Camera access authorized.")
            return true
        case .notDetermined: // 아직 결정이 되지 않은 상태
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied: // 거부가 된 상태
            print("Camera access denied")
            return false
        case .restricted: // 일부 접근이 제한된 상태
            print("Camera library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
    // 캡쳐 세션 설정 (실제 사진 프리뷰와 촬영을 매니징 할 인스턴스의 구성을 설정)
    private func configureCaptureSession(completionHandler: (_ success: Bool)->Void){
        print("configureCaptureSession이 실행?")
        var success = false
        
        self.captureSession.beginConfiguration()
        
        defer{ // 이 Scope에서 가장 나중에 실행한다. + guard로 인해 return이 되어도 실행된다.
            self.captureSession.commitConfiguration()
            print("committed Configuration!!")
            completionHandler(success)
        }
        guard let captureDevice = self.captureDevice,
              let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else{
            print("Failed to obtain video input.")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
        // 캡쳐 세선에서 내보낼 데이터 세부 포맷을 설정한다. rgb, bit rate 등...
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let videoOutput = AVCaptureVideoDataOutput()
        // 이건 무슨 기법이냐...
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        guard self.captureSession.canAddInput(deviceInput) else { // 이 deviceInput을 caputureSession이 사용할 수 있는가
            print("Unable to add device input to capture session.")
            return
        }
        guard self.captureSession.canAddOutput(photoOutput) else { // 이 photoOutput을 caputureSession이 사용할 수 있는가
            print("Unable to add photo output to capture session.")
            return
        }
        guard self.captureSession.canAddOutput(videoOutput) else { // 이 videoOutput을 captureSession이 사용할 수 있는가
            print("Unable to add video output to capture session.")
            return
        }
        self.captureSession.addInput(deviceInput)
        self.captureSession.addOutput(photoOutput)
        self.captureSession.addOutput(videoOutput)
        
        photoOutput.isHighResolutionCaptureEnabled = true
//        photoOutput.maxPhotoDimensions = .init()
        
        photoOutput.maxPhotoQualityPrioritization = .quality
        
        // preview를 위한 비디오 커넥션 설정
        self.updateVideoOutputConnection()
        
        self.isCaptureSessionConfigured = true
        
        success = true
    }
    // 전면 카메라 좌우 반전 메서드
    private func updateVideoOutputConnection() {
        if let videoOutput = self.videoOutput, let videoOutputConnection = videoOutput.connection(with: .video) {
            if videoOutputConnection.isVideoMirroringSupported {
                // 전면 카메라는 좌우가 반전되어야 한다.
                videoOutputConnection.isVideoMirrored = isUsingFrontCaptureDevice
            }
        }
    }
//     AVCaptureVideoOutput에서 사진을 찍히고 난 후 실행할 메서드 (delegate)
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) 실행")
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        if connection.isVideoOrientationSupported, let videoOrientation = videoOrientationFor(deviceOrientation){
            connection.videoOrientation = videoOrientation
        }
        // 프리뷰 이미지를 yield하는 클로져
        self.addToPreviewStream?(CIImage(cvImageBuffer: pixelBuffer))
    }
}
//MARK: -- 카메라에서 사진을 찍는 곳
extension Camera: AVCapturePhotoCaptureDelegate{
    func takePhoto(){
        guard let photoOutput = self.photoOutput else {return}
        
        sessionQueue.async {
            var photoSettings = AVCapturePhotoSettings()
            
            // 코덱 타입 설정 -> hevc가 가능하면 추가
            if photoOutput.availablePhotoCodecTypes.contains(.hevc){
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.hevc])
            }
            
            // 카메라 기기가 플레시가 가능한지 알아낸다.
            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            photoSettings.flashMode = isFlashAvailable ? .auto : .off
            // 고해상도로 저장하게 설정
            photoSettings.isHighResolutionPhotoEnabled = true
            // 픽셀 포맷 설정 -> rgba
            if let previewPhotoPixelFormetType = photoSettings.availablePreviewPhotoPixelFormatTypes.first{
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormetType]
            }
            // 사진 퀄리티 우선순위 설정 -> balanced -> 알아서 해줘잉
            photoSettings.photoQualityPrioritization = .balanced
            
            // 사진 출력 연결기
            if let photoOutputVideoConnection = photoOutput.connection(with: .video){
                if photoOutputVideoConnection.isVideoOrientationSupported,
                   // 현재 기기의 방위(UIDeviceOrentation)를 AVCaptureVideoOrientation 타입으로 바꾼다.
                   let videoOrientation = self.videoOrientationFor(self.deviceOrientation){
                    photoOutputVideoConnection.videoOrientation = videoOrientation
                }
            }
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    // AVCapturePhotoOutput에서 사진을 찍히고 난 후 실행할 메서드 (delegate)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        // 파라미터로 사진을 넘기면 yield 처리를 한다.
        addToPhotoStream?(photo)
    }
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation?{
        switch deviceOrientation{
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default:
            return nil
        }
    }
    
}

*/
