//
//  UIColorToHex.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/13.
//

import Foundation
import UIKit
import SwiftUI
extension UIColor {
    func toColor()->Color {
        guard let components:[CGFloat] = self.cgColor.components else {return Color.white}
        if components.count == 2 {
            return Color(red: 0, green: 0, blue: 0,opacity: components[0])
        }else{
            return Color(red: components[0], green: components[1], blue: components[2])
        }
    }

}
