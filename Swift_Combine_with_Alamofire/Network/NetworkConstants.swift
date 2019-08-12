//
//  NetworkConstants.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/07/25.
//  Copyright © 2019 h.crane. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Constants

struct NetworkConstants {
    
    // MARK: Variables
      
    static var baseURL: String = {
        #if DEBUG
        return "https://qiita.com"
        #else
        return "https://qiita.com"
        #endif
    }()
    
    static let header: HTTPHeaders = [
        "Accept-Encoding": "",
        "Accept-Language": "",
        "User-Agent": ""
    ]
}
