//
//  UIWindow.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/22.
//

import Foundation
import UIKit

extension UIScreen {
    static var topSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }   
}
