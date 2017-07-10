//
//  PostLikeModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct PostLikeModel {
    let followingUserNames: [String]
    let count: Int
    let ILikeIt: Bool
}

extension PostLikeModel: Decodable {
    static func decode(_ e: Extractor) throws -> PostLikeModel {
        return PostLikeModel(
            followingUserNames: try e <|| "followingUserNames",
            count: try e <| "count",
            ILikeIt: try e <| "liked"
        )
    }
}
