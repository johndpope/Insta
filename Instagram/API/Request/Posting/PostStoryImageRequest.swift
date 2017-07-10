//
//  PostStoryImageRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/23.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostStoryImageRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let userId: Int
    let imageData: Data
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/postImageStory"
    }
    
    var bodyParameters: BodyParameters? {
        var uid = userId
        let uidData = Data(bytes: &uid, count: MemoryLayout<Int>.size)
        let userIdPart = MultipartFormDataBodyParameters.Part(data: uidData, name: "userId")
        
        let imagePart = MultipartFormDataBodyParameters.Part(
            data: imageData,
            name: "image",
            mimeType: "image/png",
            fileName: "hello.png"
        )
        
        return MultipartFormDataBodyParameters(
            parts: [userIdPart, imagePart]
        )
    }
}
