//
//  MapQueryDataService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/30.
//

import Foundation
import Combine
final class MapQueryDataService{
    static private let baseURL = "https://dapi.kakao.com/v2/local/"
    static private let queryURL = "search/address?query="
    static private let geoURL = "geo/coord2address.json?"
    var mapQueryDataCancellable: AnyCancellable?
    var subscription = Set<AnyCancellable>()
    var geoPassthrough = PassthroughSubject<String,Never>()
    @Published var queryResult: MapQueryModel? = nil
    init(){}
    deinit{
        subscription.forEach { ele in
            ele.cancel()
        }
    }
    func getMapCoordinate(query:String){
        let urlStr = "\(MapQueryDataService.baseURL)\(MapQueryDataService.queryURL)\(query)"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else {
            print("출력이 안돼요")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(Bundle.getKakaoRestApi)", forHTTPHeaderField: "Authorization")
        print("getMapCoordinate(query:String) 출력")
        NetworkingManager.upload(request: request)
            .tryMap({ (data) -> MapQueryModel in
                guard let queryResult = try? JSONDecoder().decode(MapQueryModel.self, from: data) else{
                    throw fatalError("맵 쿼리 요청 오류")
                }
                return queryResult
            }).sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] queryResult in
                self?.queryResult = queryResult
            })
            .store(in: &subscription)
    }
}
