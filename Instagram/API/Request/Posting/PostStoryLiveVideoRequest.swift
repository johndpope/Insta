//
//  PostStoryLiveVideoRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostStoryLiveVideoRequest: InstagramRequest {
    typealias Response = LiveStoryModel
    
    let userId: Int
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/startLive"
    }
    
    var parameters: Any? {
        return [
            "userId": userId
        ]
    }
}
