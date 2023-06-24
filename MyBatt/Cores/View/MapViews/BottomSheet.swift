//
//  BottomSheet.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/24.
//

import SwiftUI

struct BottomSheet: View {
    @State private var txt = ""
    @Binding var offset: CGFloat
    var value : CGFloat
    var body: some View {
        VStack{
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 50,height: 5)
                .padding(.top)
                .padding(.bottom,5)
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                TextField("Search Place", text: $txt)
//                { status in
//                    withAnimation {
//                        offset = value
//                    }
//                }onCommit: {
//
//                }
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Material.bar)
            .cornerRadius(15)
            .padding()
            ScrollView(.vertical,showsIndicators: false) {
                LazyVStack(alignment: .leading,spacing:15) {
                    ForEach(1...15,id:\.self){ count in
                        Text("Searched Place")
                    }
                }
            }
        }
        .cornerRadius(15)
        .background(Color.white)
    }
}

//struct BottomSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheet()
//    }
//}
