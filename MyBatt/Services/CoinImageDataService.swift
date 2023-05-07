//
//  CoinImageDataService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
import UIKit
import SwiftUI
class CoinImageDataService{
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    init(urlString: String){
        getCoinImage(urlString: urlString)
        print("CoinImageDataService init")
    }
    private func getCoinImage(urlString: String){
        guard let url = URL(string: urlString) else {
            print("There is no ulr string")
            return
        }
//        URLSession.shared.dataTaskPublisher(for: url)
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw fatalError("UIImage Wrong")
                }
                return image
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:)) { [weak self] (image: UIImage) in
                print("getCoinImage sinked")
                self?.image = image
                self?.imageSubscription?.cancel()
        }
    }
}
