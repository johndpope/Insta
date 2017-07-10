//
//  GetProfileRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/19.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit


struct GetProfileRequest: InstagramRequest {
    typealias Response = ProfileModel
    
    let userId: Int
    let myUserId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getProfile"
    }
    
    var queryParameters: [String : Any]? {
        return [
            "userId": userId,
            "myUserId": myUserId
        ]
    }
}
