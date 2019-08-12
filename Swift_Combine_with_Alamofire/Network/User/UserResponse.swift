//
//  QiitaResponse.swift
//  Swift_Combine_with_Alamofire
//
//  Created by admin on 2019/08/12.
//  Copyright © 2019 h.crane. All rights reserved.
//

// MARK: - Response

struct UserResponse: Codable {
    var data: [UserModel]
}

struct UserModel: Codable {
    let name: String
    let id: Int
}


/* ex
 {
   "data": [
     {
       "name": "Bob",
       "id": "0"
     },
     {
       "name": "Sam",
       "id": "1"
     }
   ]
 }
 */
