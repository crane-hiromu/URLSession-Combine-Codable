//
//  NetworkPublisher.swift
//  Administration_DX_App
//
//  Created by h.crane on 2021/10/29.
//

import Foundation
import Combine

// MARK: - NetworkPublisher
struct NetworkPublisher {

    // MARK: Variables

    private static let successRange = 200..<300
    private static let retryCount: Int = 1
    private static let decorder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    // MARK: Methods

    static func publish<T, V>(_ request: T) -> AnyPublisher<V, NetworkError>
        where T: BaseRequestProtocol, T.ResponseType == V {

            return URLSession.shared
                .dataTaskPublisher(for: try! request.asURLRequest())
                .timeout(.seconds(20), scheduler: DispatchQueue.main)
                .retry(retryCount)
                .validate(statusCode: successRange)
                .decode(type: V.self, decoder: decorder)
                .mapDecodeError()
                .eraseToAnyPublisher()
    }
}

// MARK: - Private Extension
private extension Publisher {
    
    func validate<S>(statusCode range: S) -> Publishers.TryMap<Self, Data>
        where S:Sequence, S.Iterator.Element == Int {
        
        tryMap {
            guard let output = $0 as? (Data, HTTPURLResponse) else {
                throw NetworkError.irregularError(info: "irregular error")
            }
            guard range.contains(output.1.statusCode) else {
                throw NetworkError.networkError(code: output.1.statusCode, description: "out of statusCode range")
            }
            return output.0
        }
    }
    
    func mapDecodeError() -> Publishers.MapError<Self, NetworkError> {
        mapError {
            switch $0 as? DecodingError {
            case .keyNotFound(_, let context):
                return .decodeError(reason: context.debugDescription)
            default:
                return .decodeError(reason: $0.localizedDescription)
            }
        }
    }
}
