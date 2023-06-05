//
//  ColorExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/04/13.
//

import Foundation
import SwiftUI

extension Color{
    static var lightGray: Self{
        Color("lightGray")
    }
    static var ambientColor: Self{
        Color("AmbientColor")
    }
    static var lightAmbientColor: Self{
        Color("LightAmbient")
    }
    init(hex:String){
        // Scanner에서 
        let scanner: Scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
            let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
            let blue = Double(hexNumber & 0x0000ff) / 255.0
            self.init(red: red, green: green, blue: blue)
            return
        }
        self.init(red: 0, green: 0, blue: 0)
    }

}
