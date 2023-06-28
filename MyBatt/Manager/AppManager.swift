//
//  AppManager.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/25.
//

import Foundation
import SwiftUI
import Combine
final class AppManager:ObservableObject{
    lazy var lastCropType: CropType = .Lettuce
    @Published var navigationBarColor: UIColor = .blue
    @Published private var viewStacks:[Bool] = []{
        didSet{
            print("\(oldValue) \(viewStacks)")
            guard !isAction else {return}
            if isAction{
                print("Popping Actioned!! \(oldValue) \(viewStacks)")
            }else{
                //                 O(1)
                guard oldValue.count == viewStacks.count else { return }
                //                 O(1) -> 중간 back을 누른 뷰가 false로 바뀐다. -> 오류 발생 중단
//                guard oldValue[oldValue.count-2] == viewStacks[viewStacks.count-2] else {return}
                guard oldValue == viewStacks else { return } //O(n)
                _ = self.viewStacks.popLast()
            }
        }
    }
    @Published var isLoginActive: Bool = false
    @Published var isTabbarHidden: Bool = false
    @Published var isCameraActive: Bool = false
    @Published var isAlbumActive: Bool = false
    @Published var isDiagnosisActive: Bool = false
    @Published var isMyInfoActive: Bool = false
    var mainViewLink = PassthroughSubject<MainLinkViewType, Never>()
    init(){
        viewStacks.append(false)
    }
    public var stackIdx: Int{
        get{
            self.viewStacks.count - 1
        }
    }
    public var screenWidth:CGFloat {
        UIScreen.main.bounds.width
    }
    public private(set) var isAction: Bool = false
    public func getBindingStack(idx:Int)->Binding<Bool>{
        let lastCount = (self.viewStacks.count - 1)
//        print(lastCount,idx)
        return Binding(get: {
            return idx == -1 ? self.viewStacks[self.stackIdx] :lastCount < idx ? false : self.viewStacks[idx]
        }, set: { bool in
            if lastCount < idx{
                self.viewStacks[lastCount] = false
            }else{
                self.viewStacks[idx] = bool
            }
        }
        )
    }
}

extension AppManager{
    func cameraRunning(isRun: Bool){
        self.isCameraActive = isRun
        withAnimation(.easeIn(duration: 0.75)) {
            isTabbarHidden = isRun
        }
    }
}

//MARK: -- Link Actions
extension AppManager{
    private func _linkAction(idx: Int){
        if idx+1 == viewStacks.count{
            self.viewStacks.append(false)
        }
        self.viewStacks[idx] = true
    }
    func linkAction()->Int{
        _linkAction(idx: self.stackIdx)
        return self.stackIdx - 1
    }
    func goRootView(){
        // 전체에서 하나만 남겨라
        guard viewStacks.count != 1 else { return }
        self.goParentView(upToIdx: viewStacks.count - 1)
    }
    func goRootToNextView(nextType: MainLinkViewType? = nil){
        guard viewStacks.count != 1 else {
            guard let nextType = nextType else { return }
            self.mainViewLink.send(nextType)
            return
        }
        self.goParentView(upToIdx: viewStacks.count - 1,nextType:nextType)
    }
    func goParentView(upToIdx: Int,nextType:MainLinkViewType? = nil){
        self.isAction = true
        let trueLen = viewStacks.count - 2
        guard viewStacks.count - 1 >= upToIdx else { print("over Idx!!")
            return }
        for i in 0..<upToIdx{
            //            print(trueLen - i)
            self.viewStacks[trueLen - i] = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            for _ in 0..<upToIdx{
                if self.viewStacks.count > 1{
                    _ = self.viewStacks.popLast()
                }
            }
            self.isAction = false
            guard let nextType = nextType else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                self.mainViewLink.send(nextType)
            }
        }
    }
}
