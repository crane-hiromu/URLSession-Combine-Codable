//
//  NetworkPublisher.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/08/13.
//  Copyright © 2019 h.crane. All rights reserved.
//

import Alamofire
import Combine

// MARK: - NetworkPublisher

struct NetworkPublisher {

    // MARK: Static Variables

    private static let successRange = 200..<300
    private static let retryCount: Int = 1
    private static let decorder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    

    // MARK: Methods

    static func sink<T, V>(_ request: T, _ scheduler: DispatchQueue = DispatchQueue.main,
                           receive: @escaping (V) -> Void,
                           failure: @escaping (Error) -> Void,
                           finished: @escaping () -> Void = {}) -> AnyCancellable
        
        where T : BaseRequestProtocol, V == T.ResponseType, T.ResponseType : Codable {
            
            publish(request)
                .receive(on: scheduler)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .finished: finished()
                    case .failure(let e): failure(e)
                    }
                }, receiveValue: receive)
    }
    
    static func publish<T, V>(_ request: T) -> AnyPublisher<V, Error>
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {

            return URLSession.shared
                .dataTaskPublisher(for: try! request.asURLRequest())
                .validateNetwork()
                .validate(statusCode: successRange)
                .retry(retryCount)
                .map { $0.data }
                .decode(type: V.self, decoder: decorder)
                .eraseToAnyPublisher()
    }
}

private extension URLSession.DataTaskPublisher {
    
    func validateNetwork() -> Self {
        tryCatch { error -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else { throw error }
            return self
        }.upstream
        
//        return self.tryCatch { error -> URLSession.DataTaskPublisher in
//            guard let reasonState = error.networkUnavailableReason else { throw error }
//
//            switch reasonState {
//            case .cellular:
//                throw error
//
//            case .expensive:
//                throw error
//
//            case .constrained:
//                return sealf
//
//            @unknown default:
//                throw error
//            }
//        }.upstream
    }
    
    func validate<S: Sequence>(statusCode range: S) -> Self
        where S.Iterator.Element == Int {
            
        tryMap { data, response -> Data in
            switch (response as? HTTPURLResponse)?.statusCode {
            case .some(let code) where range.contains(code):
                return data
            case .some(let code) where !range.contains(code):
                throw NSError(domain: "out of statusCode range", code: code)
            default:
                throw NSError(domain: String(data: data, encoding: .utf8) ?? "Network Error", code: 0)
            }
        }.upstream
    }
}
