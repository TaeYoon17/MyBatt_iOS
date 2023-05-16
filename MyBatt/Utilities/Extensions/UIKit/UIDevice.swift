//
//  UIDevice.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/17.
//

import Foundation
import UIKit
extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return false }
        return window.safeAreaInsets.top > 20
    }
}


