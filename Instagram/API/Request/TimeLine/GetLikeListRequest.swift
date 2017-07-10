//
//  GetLikeListRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct GetLikeListRequest: InstagramRequest {
    typealias Response = LikeListsModel
    
    let userId: Int
    let postId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getLikeList"
    }
    
    var queryParameters: [String : Any]? {
        return [
            "userId": userId,
            "postId": postId,
        ]
    }
}
