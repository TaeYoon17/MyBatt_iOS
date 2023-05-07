//
//  OutBreakViewMoel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
final class OutBreakViewMoel: ObservableObject{
    @Published var outbreaks: [CoinModel] = []
    
    private let dataService = OutBreakDataService()
    var cancellables: Set<AnyCancellable> = []
    init(){
        addSubscribers()
    }
    func downloadData(){
        guard let url = URL(string: "www.naver.com") else { return }
    }
    func addSubscribers(){
        dataService.$outbraeks.sink { [weak self] outbreaks in
            self?.outbreaks = outbreaks
        }.store(in: &cancellables)
    }
}
