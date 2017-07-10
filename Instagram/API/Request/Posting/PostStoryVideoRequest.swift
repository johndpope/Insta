//
//  PostStoryVideoRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostStoryVideoRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let userId: Int
    let videoData: Data
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/postVideoStory"
    }
    
    var bodyParameters: BodyParameters? {
        var uid = userId
        let uidData = Data(bytes: &uid, count: MemoryLayout<Int>.size)
        let userIdPart = MultipartFormDataBodyParameters.Part(data: uidData, name: "userId")
        
        let imagePart = MultipartFormDataBodyParameters.Part(
            data: videoData,
            name: "video",
            mimeType: "video/quicktime",
            fileName: "hello.mov"
        )
        
        return MultipartFormDataBodyParameters(
            parts: [userIdPart, imagePart]
        )
    }
}
