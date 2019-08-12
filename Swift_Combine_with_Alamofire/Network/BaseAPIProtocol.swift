//
//  BaseAPIProtocol.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/07/25.
//  Copyright © 2019 h.crane. All rights reserved.
//

import Alamofire
import Combine

// MARK: - Base API Protocol

protocol BaseAPIProtocol {
    associatedtype ResponseType

    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var allowsConstrainedNetworkAccess: Bool { get }
}

extension BaseAPIProtocol {

    var baseURL: URL {
        return try! NetworkConstants.baseURL.asURL()
    }

    var headers: HTTPHeaders? {
        return NetworkConstants.header
    }
    
    var allowsConstrainedNetworkAccess: Bool {
        return true
    }
}

// MARK: - BaseRequestProtocol

protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    
    var encoding: URLEncoding {
        return URLEncoding.default
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = TimeInterval(30)
        urlRequest.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess

        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }

        return urlRequest
    }
}

