//
//  GetMoreMyTimeLineRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/25.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct GetMoreMyTimeLineRequest: InstagramRequest {
    typealias Response = TimeLineModel
    
    let userId: Int
    let limit: Int
    let untilId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getMyTimeLine"
    }
    
    var queryParameters: [String : Any]? {
        return [
            "userId": userId,
            "limit": limit,
            "untilId": untilId
        ]
    }
}
