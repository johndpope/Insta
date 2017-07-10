//
//  PostCommentRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostCommentRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let userId: Int
    let postId: Int
    let content: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/postComment"
    }
    
    var parameters: Any? {
        return [
            "userId": userId,
            "postId": postId,
            "content": content
        ]
    }
}
