//
//  SearchMainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/26.
//

import Foundation
final class SeaerchMainVM: ObservableObject{
    @Published var searchText = ""
    @Published var data:[Item] = dummies()
    @Published var searchResults: [Item] = []
}
