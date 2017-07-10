//
//  PostingImageModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation

struct PostingImageModel {
    var userId: Int
    var imageData: Data?
    var caption: String
    var tags: String
    var location: String
    
    init(userId: Int = 1, imageData: Data? = nil, caption: String = "", tags: String = "", location: String = "") {
        self.userId = userId
        self.imageData = imageData
        self.caption = caption
        self.tags = tags
        self.location = location
    }
}
