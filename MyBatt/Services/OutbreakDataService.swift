//
//  OutbreakDataService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
class OutBreakDataService{
    static private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=ko"
    @Published var outbraeks: [CoinModel] = []
    var coinCancellable: AnyCancellable?
    init(){
        getOutbreaks()
    }
    private func getOutbreaks(){
        guard let url = URL(string: OutBreakDataService.urlString) else { return }
        coinCancellable = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] coins in
                self?.outbraeks = coins
                self?.coinCancellable?.cancel()
            })
    }
}
