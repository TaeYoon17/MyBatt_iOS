//
//  MapMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//

import SwiftUI
import NativePartialSheet
import CoreLocation
import MapKit
import Combine

struct MapMainView: View {
    
    @EnvironmentObject var appManager: AppManager
    @StateObject private var vm = MapMainVM()
    @StateObject private var sheetVm = MapSheetVM()
    //    @StateObject private var mapVM = MapVM<Marker>()
    @State var detent: Detent = .height(70)
    @State var zoomLevel:Int = 1
    @State var isPresent = false
    @State var isFilter = false
    @State var offset: CGFloat = 0
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                MapView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
                    .sheet(isPresented: $isPresent){
                        MapSheetView(isGPSOn: $vm.isGPSOn)
                            .environmentObject(vm)
                            .environmentObject(sheetVm)
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
            NavigationLink(isActive: $isFilter) {
                MapFilterView()
                    .environmentObject(vm)
                    .onAppear(){
                        DispatchQueue.main.async{
                            self.isPresent = false
                        }
                    }
            } label: {
                EmptyView()
            }
        }
        .onChange(of: vm.isPresent, perform: { newValue in
            print(newValue)
            self.isPresent = newValue
        })
        .onAppear(){
            appManager.isTabbarHidden = true
            self.vm.isGPSOn = true
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                self.vm.isGPSOn = false
            }
        }
        .onDisappear(){
            print("이게 사라지네...")
            vm.isPresent = false
            withAnimation(.easeOut(duration: 0.2)) {
                if !isFilter{
                    appManager.isTabbarHidden = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    vm.isPresent = false
                    appManager.goRootView()
                } label: {
                    HStack(spacing:4){
                        Image(systemName: "chevron.left").font(.headline)
                        Text("Back")
                    }
                }.padding(.horizontal, -8)
            }
            ToolbarItem(placement: .principal) {
                Text("\(vm.locationName)")
                    .fontWeight(.semibold)
                    .frame(width: 200,height: 44)
                //                    .background(Color.blue)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavTrailingBtn(btnAction: {
                    print("팝업")
                    self.isFilter = true
                }, imgName: "line.3.horizontal.decrease.circle", labelName: "필터", textColor: .white, bgColor: .accentColor)
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
