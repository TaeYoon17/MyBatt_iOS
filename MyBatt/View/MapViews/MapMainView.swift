//
//  MapMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/04.
//

import SwiftUI

struct MapMainView: View {
    var body: some View {
        VStack{
            KakaoMapViewWrapper()
        }
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
    }
}
