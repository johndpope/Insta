//
//  timeLineModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct TimeLineModel {
    let stories: [StoryModel]
    let posts: [PostModel]
}

extension TimeLineModel: Decodable {
    static func decode(_ e: Extractor) throws -> TimeLineModel {
        return TimeLineModel(
            stories: try e <|| "stories",
            posts: try e <|| "posts")
    }
}
