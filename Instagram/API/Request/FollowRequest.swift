//
//  FollowRequest.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct FollowRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let userId: Int
    let myUserId: Int
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/follow"
    }
    
    var parameters: Any? {
        return [
            "userId": userId,
            "myUserId": myUserId
        ]
    }
}
