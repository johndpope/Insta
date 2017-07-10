//
//  StoryModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct StoryModel {
    let userId: Int
    let userName: String
    let userIconURL: String
    let imageStory: String?
    let videoStory: String?
}

extension StoryModel: Decodable {
    static func decode(_ e: Extractor) throws -> StoryModel {
        return StoryModel(
            userId: try e <| "userId",
            userName: try e <| "userName",
            userIconURL: try e <| "userIcon",
            imageStory: try e <|? "image",
            videoStory: try e <|? "video"
        )
    }
}
