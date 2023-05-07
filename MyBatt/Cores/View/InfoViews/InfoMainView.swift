//
//  InfoMainView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/05.
//

import SwiftUI

struct InfoMainView: View {
    var body: some View {
        Form {
            Section {
                Text("Hello world")
            } header: {
                Text("개인설정")
            }
            
            Section {
                Text("여기에 뭘 넣을까...")
            }
        }
    }
}

struct InfoMainView_Previews: PreviewProvider {
    static var previews: some View {
        InfoMainView()
    }
}
