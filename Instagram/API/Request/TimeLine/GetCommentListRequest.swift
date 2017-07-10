//
//  GetCommentListRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct GetCommentListRequest: InstagramRequest {
    typealias Response = CommentListsModel
    
    let postId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getCommentList"
    }
    
    var queryParameters: [String : Any]? {
        return [
            "postId": postId,
        ]
    }
}
