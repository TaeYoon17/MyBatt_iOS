//
//  CameraView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/22.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var appManager: AppManager
    @StateObject private var model = CameraViewModel()
    @State private var isPhotoTaken = false
    private static let barHeightFactor = 0.15
    var body: some View {
        NavigationView {
            cameraView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(id: "BackButton",placement: .navigationBarLeading) {
                        //여기 폰트 수정
                        Button {
                            appManager.cameraRunning(isRun: false)
                        } label: {
                            Image(systemName: "xmark").imageScale(.large).foregroundColor(.white)
                        }
                    }
                    ToolbarItem(id: "CenterText",placement: .principal) {
                        //여기 폰트 수정
                        Text("작물을 촬영하세요").foregroundColor(.white)
                    }
                })
                .task {
                    await model.camera.start() // 카메라 실행하는 메서드
                    print("start")
                }
        }
        .background(Color.white)
        .onAppear(){
            Appearances.navigationBarClear()
            //            UINavigationBar.applyCustomAppearance()
//            Task{
//                await model.camera.start()
//            }
        }.onDisappear(){
            Appearances.navigationBarWhite()
            model.camera.stop()
        }
    }
    private var cameraView: some View{
        GeometryReader{proxy in
            ViewfinderView()
                .environmentObject(model)
                .overlay(
                    Color.white.opacity(0.5).frame(height: 0)
                    ,alignment: .top
                )
                .overlay(buttonsView()
                    .frame(width: proxy.size.width,
                           height: (proxy.size.height-proxy.size.width) / 2
                           //                           height:  proxy.size.height * Self.barHeightFactor
                          )
                        .background(Color.black.opacity(0.5))
                         ,alignment: .bottom)
                .overlay(Color.clear
                    .frame(height: proxy.size.height * (1 - (Self.barHeightFactor * 2)))
                    .accessibilityElement()
                    .accessibilityLabel("View Finder")
                    .accessibilityAddTraits([.isImage])
                         ,alignment: .center)
                .background(Color.black)
            
        }
        
    }
    private func buttonsView() -> some View {
        HStack(spacing:60) {
            Spacer()
            //MARK: -- 사진첩
            /*
            NavigationLink {
                //                    PhotoCollectionView(photoCollection: model.photoCollection)
                //                        .onAppear {
                //                            model.camera.isPreviewPaused = true
                //                        }
                //                        .onDisappear {
                //                            model.camera.isPreviewPaused = false
                //                        }
            } label: {
                Label {
                    Text("Gallery")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                } icon: {
                    Image(systemName: "photo")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .scaledToFit()
                }.foregroundColor(.blue)
            }
             */
//            Spacer()
            //MARK: -- 사진 셔터
            NavigationLink(isActive:$isPhotoTaken) {
                TakenPhotoView(takenView: $isPhotoTaken)
                    .environmentObject(model)
                    .onAppear(){
//                        model.camera.isPreviewPaused = true
                    }.onDisappear(){
//                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Button {
                    model.camera.takePhoto()
                    model.locationService.updateCurrent()
                    isPhotoTaken = true
                    DispatchQueue.global(qos: .default).asyncAfter(deadline:.now()+1){
                        model.camera.stop()
                    }
                } label: {
                    Label {
                        Text("Take Photo")
                            .foregroundColor(.blue)
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }.scaledToFit()
                }
            }
            
            /*
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .scaledToFit()
            }
             */
            Spacer()
            
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView {
        CameraView()
        //        }
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
