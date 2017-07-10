//
//  PostLikeRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/17.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostLikeRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let userId: Int
    let postId: Int
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/postLike"
    }
    
    var parameters: Any? {
        return [
            "userId": userId,
            "postId": postId
        ]
    }
}
