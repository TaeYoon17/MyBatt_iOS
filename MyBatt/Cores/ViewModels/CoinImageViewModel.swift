//
//  CoinImageViewModel.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
class CoinImageViewModel: ObservableObject{
    
    @Published var image:UIImage? = nil
    @Published var isLoading:Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageDataService
    private var cancellable = Set<AnyCancellable>()
    init(coin: CoinModel){
        print("CoinImageViewModel Init")
        self.coin = coin
        self.dataService = CoinImageDataService(urlString: coin.image)
        self.addSubscribers()
        self.isLoading = true
    }
    private func getImage(){
    }
    private func addSubscribers(){ // 의존성 주입
        let imagePublisher: Published<UIImage?>.Publisher = dataService.$image
        imagePublisher.sink{[weak self] output in
            print("dataService.$image called")
            self?.image = output
            self?.isLoading = false
        }.store(in: &cancellable)
    }
}
