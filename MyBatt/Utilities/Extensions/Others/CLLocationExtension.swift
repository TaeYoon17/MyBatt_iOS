//
//  CLLocationExtension.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import Foundation
import CoreLocation
extension CLLocationCoordinate2D{
    init(geo:Geo){
        self.init(latitude: geo.latitude, longitude: geo.longtitude)
    }
}
