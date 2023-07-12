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
    @State var detent: Detent = .height(68)
    @State var isPresent = false
    @State var isFilter = true
    @State var isToolbarFilter = true
    @State var offset: CGFloat = 0
    @State var tappedItem: (any Markerable)? = nil
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
                    .presentationDetents([.large,.height(68)],selection: $detent)
                    .cornerRadius(16)
                    .presentationDragIndicator(.hidden)
                    .sheetColor(.clear)
                    .edgeAttachedInCompactHeight(true)
                    .scrollingExpandsWhenScrolledToEdge(true)
                    .widthFollowsPreferredContentSizeWhenEdgeAttached(true)
                    .largestUndimmedDetent(.height(68))
                    .interactiveDismissDisabled(false,
                                                onWillDismiss: {
                        print("willDismiss")
                    },
                                                onDidDismiss: {
                        self.vm.isPresent = false
                    }).zIndex(0)
            if let tapped =  tappedItem{
                let item = tapped.info
                MapItemView(item: item,bgColor: .white.opacity(0.8))
                        .padding(.bottom,100)
                        .padding(.horizontal)
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                        .zIndex(1)
            }else{
                EmptyView()
            }
            if isFilter{
                MapFilterView()
                .environmentObject(vm)
                .transition(.move(edge: .bottom))
                .zIndex(2)
            }
        }
        .onReceive(vm.$tappedItem, perform: { output in
                print("vm.$tappedItem, perform: { output in")
                self.tappedItem = output
        })
        .onReceive(vm.$isPresent, perform: { output in
            self.isPresent = output
        })
        .onAppear(){
            appManager.isTabbarHidden = true
//            self.vm.isGPSOn = true
//            DispatchQueue.main.asyncAfter(deadline: .now()+1){
//                self.vm.isGPSOn = false
//            }
        }
        .onDisappear(){
            withAnimation(.easeOut(duration: 0.2)) {
                if !isFilter{
                    appManager.isTabbarHidden = false
                }
            }
            print("MapMainView 사라짐!!!")
        }
        .navigationBarBackground({ Color.clear })
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
                            .font(.system(size:16))
                    }.padding(.all,8)
                        .background(isFilter ? .clear : .white)
                        .cornerRadius(8)
                }.padding(.horizontal, -8)
                    .disabled(isFilter)
            }
            ToolbarItem(placement: .principal) {
                Text("\(vm.locationName)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal,6)
                    .padding(.vertical,2)
                    .frame(width: 200,height: 40)
                    .background(isFilter ? .clear : .white.opacity(0.8))
                    .cornerRadius(8)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavTrailingBtn(btnAction: {
                    print("팝업")
                    vm.isPresent = self.isFilter
                    vm.tappedItem = nil
                    self.isToolbarFilter.toggle()
                    withAnimation(.linear(duration: 0.25)) {
                        self.isFilter.toggle()
                    }
                }, imgName: isToolbarFilter ? "" : "checklist",
                               labelName: isToolbarFilter ? "닫기" : "필터",
                               textColor: isToolbarFilter ? .accentColor :.white,
                               bgColor: isToolbarFilter ? .clear : .accentColor)
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
