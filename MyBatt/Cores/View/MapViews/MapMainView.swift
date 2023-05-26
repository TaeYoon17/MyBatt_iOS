//
//  MapMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//

import SwiftUI
import NativePartialSheet
import CoreLocation
struct MapMainView: View {
    @EnvironmentObject var appManager: AppManager
    @StateObject private var vm = MapSheetVM()
    @State var isPresent = false
    @State var detent: Detent = .height(70)
    @State var zoomLevel:Int = 1
    @State var center: Geo = (37.603406,127.142995)
    @State var isTracking: Bool? = false
    let circles: [Geo] = []
    var body: some View {
        ZStack{
            KakaoMapViewWrapper(zoomLevel: $zoomLevel,center: $center,address: $vm.locationName,isTrackingMode: $vm.isGPSOn)
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    Text(zoomLevel.description)
                        .background(.white)
                })
                .sheet(isPresented: $isPresent){
                    MapSheetView().environmentObject(vm)
                }
                .presentationDetents([.large,.height(70)],selection: $detent)
                .cornerRadius(16)
                .presentationDragIndicator(.hidden)
                .sheetColor(.clear)
                .edgeAttachedInCompactHeight(true)
                .scrollingExpandsWhenScrolledToEdge(true)
                .widthFollowsPreferredContentSizeWhenEdgeAttached(true)
                .largestUndimmedDetent(.height(70))
                .interactiveDismissDisabled(false,
                                            onWillDismiss: {
                    print("willDismiss")
                },
                                            onDidDismiss: {
                    print("isDismissed")
                })
                
        }
        .onTapGesture {
            isPresent.toggle()
        }
        .onAppear(){
            appManager.isTabbarHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.vm.isGPSOn = false
            }
        }
        .onDisappear(){
            withAnimation(.easeOut(duration: 0.2)) {
                appManager.isTabbarHidden = false
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    self.isPresent = false
                    appManager.goRootView()
                } label: {
                    HStack(spacing:4){
                        Image(systemName: "chevron.left").font(.headline)
                        Text("Back")
                    }
                }.padding(.horizontal, -8)
            }
            ToolbarItem(placement: .principal) {
//                Text("경기도 구리시 인창동")
//                Text("\(self.center.latitude) - \(self.center.longtitude)")
                Text("\(vm.locationName ?? "")")
                    .fontWeight(.semibold)
            }
        }
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MapMainView().environmentObject(AppManager())
        }
    }
}



//            let isPresented = false
//            guard let window = UIApplication.shared.keyWindow else { return }
//            guard let rootViewController = window.rootViewController else { return }
//            let presentedViewController = rootViewController.presentedViewController
//            rootViewController.dismiss(animated: false)
