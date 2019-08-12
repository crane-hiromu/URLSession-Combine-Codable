//
//  QiitaRequest.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/08/12.
//  Copyright © 2019 h.crane. All rights reserved.
//

import Alamofire

// MARK: - Request

struct UserRequest: BaseRequestProtocol {
    typealias ResponseType = UserResponse

    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: URL {
        return URL(string: "https://api.myjson.com")!
    }

    var path: String {
        return "/bins/o5g6r"
    }

    var parameters: Parameters? {
        return nil
    }
}
