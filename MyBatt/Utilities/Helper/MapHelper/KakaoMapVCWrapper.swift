//
//  KakaoMapVCWrapper.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//
import Foundation
import UIKit
import SwiftUI

struct KakaoMapVCWrapper: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        return KakaoMapVC()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
struct KakaoMapViewWrapper: UIViewRepresentable{
    func makeUIView(context: Context) -> KakaoMapUIView {
        KakaoMapUIView()
    }
    
    typealias UIViewType = KakaoMapUIView
    
    func makeCoordinator() -> Coordinator {
        
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class KakaoMapUIView: MTMapView{
    init(){
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
}
class KakaoMapVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MTMapView(frame: self.view.frame)
//        mapView.delegate = self
        mapView.baseMapType = .hybrid
        self.view.addSubview(mapView)
    }
}
