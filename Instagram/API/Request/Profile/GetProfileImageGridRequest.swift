//
//  GetProfileImageGridRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit


struct GetProfileImageGridReqeust: InstagramRequest {
    typealias Response = ProfileImagesGridModel
    
    let userId: Int
    let untilPostId: Int?
    let limit: Int?
    
    var q: [String: Any]?
    
    init(userId: Int, untilPostId: Int? = nil, limit: Int? = nil) {
        self.userId = userId
        self.untilPostId = untilPostId
        self.limit = limit
        
        q = [:]
        q?["userId"] = self.userId
        if let pid = self.untilPostId {
            q?["untilPostId"] = pid
        }
        if let lim = self.limit {
            q?["limit"] = lim
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getProfileImageGrid"
    }
    
    var queryParameters: [String : Any]? {
        return q
    }
}

