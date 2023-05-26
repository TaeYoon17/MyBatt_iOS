//
//  NetworkingManager.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/05/07.
//

import Foundation
import Combine
final class NetworkingManager{
    
    enum NetworkError: LocalizedError{
        case badRequestResponse
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badRequestResponse: return "[🔥] Bad response from URL."
            case .unknown: return "[⚠️] Unknown error occured."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data,Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0)  }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    static private func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response: HTTPURLResponse = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            print("URL 코드 오류 \(output.response.description)")
            throw URLError(.badServerResponse)
        }
        print("output.response \(response.statusCode)")
        return output.data
    }
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    static func upload(request: URLRequest) -> AnyPublisher<Data,Error>{
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.global(qos: .default))
            .tryMap {
                print("taskpublisher 보내기")
                return try handleURLResponse(output: $0)
                
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
