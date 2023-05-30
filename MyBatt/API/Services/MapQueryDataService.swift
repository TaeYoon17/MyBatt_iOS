//
//  MapQueryDataService.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/30.
//

import Foundation

import Combine
final class MapQueryDataService{
    static private let urlString = "https://dapi.kakao.com/v2/local/search/address?query="
    var mapQueryDataCancellable: AnyCancellable?
    @Published var queryResult: MapQueryModel? = nil
    init(){
    }
    deinit{
        self.mapQueryDataCancellable?.cancel()
    }
    func getMapCoordinate(query:String){
        let urlStr = "\(MapQueryDataService.urlString)\(query)"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else {
            print("출력이 안돼요")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(Bundle.getKakaoRestApi)", forHTTPHeaderField: "Authorization")
        print("getMapCoordinate(query:String) 출력")
        self.mapQueryDataCancellable = NetworkingManager.upload(request: request)
//            .sink(receiveCompletion: { completion in
//                switch completion{
//                case .finished:
//                    print("finished")
//                case .failure(let fail):
//                    print(fail)
//                }
//            }, receiveValue: { data in
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print(jsonString)
//                }
//            })
            .tryMap({ (data) -> MapQueryModel in
                guard let queryResult = try? JSONDecoder().decode(MapQueryModel.self, from: data) else{
                    throw fatalError("맵 쿼리 요청 오류")
                }
                return queryResult
            }).sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] queryResult in
                self?.queryResult = queryResult
            })
    }
}
