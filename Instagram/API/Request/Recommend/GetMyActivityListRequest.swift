//
//  GetMyActivityListRequest.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct GetMyActivityListRequest: InstagramRequest {
    typealias Response = MyActivitiesModel
    
    let userId: Int
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/getMyActivityList"
    }
    
    var parameters: Any? {
        return [
            "userId": userId
        ]
    }
}
