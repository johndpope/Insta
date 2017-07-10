//
//  LiveStoryModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct LiveStoryModel {
    let path: String
    let key: String
}

extension LiveStoryModel: Decodable {
    static func decode(_ e: Extractor) throws -> LiveStoryModel {
        return LiveStoryModel(
            path: try e <| "path",
            key: try e <| "streamKey"
        )
    }
}
