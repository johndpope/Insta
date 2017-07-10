//
//  PostImageRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit

struct PostImageRequest: InstagramRequest {
    typealias Response = StatusResponse
    
    let posting: PostingImageModel
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/postImage"
    }
    
    var bodyParameters: BodyParameters? {
        var uid = posting.userId
        let uidData = Data(bytes: &uid, count: MemoryLayout<Int>.size)
        let userIdPart = MultipartFormDataBodyParameters.Part(data: uidData, name: "userId")
        
        let imagePart = MultipartFormDataBodyParameters.Part(
            data: posting.imageData!,
            name: "image",
            mimeType: "image/png",
            fileName: "hello.png"
        )
        
        let captionPart = MultipartFormDataBodyParameters.Part(data: posting.caption.toDataUTF8(), name: "caption")
        let tagsPart = MultipartFormDataBodyParameters.Part(data: posting.tags.toDataUTF8(), name: "tags")
        let locationPart = MultipartFormDataBodyParameters.Part(data: posting.location.toDataUTF8(), name: "location")
        
        return MultipartFormDataBodyParameters(
            parts: [userIdPart, imagePart, captionPart, tagsPart, locationPart]
        )
     }
}
