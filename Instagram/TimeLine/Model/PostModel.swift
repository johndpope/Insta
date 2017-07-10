//
//  PostModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct PostModel {
    let id: Int
    let postedAt: String
    let user: PostUserModel
    let image: PostImageModel
    let like: PostLikeModel
    let comments: [PostCommentModel]
}

extension PostModel: Decodable {
    static func decode(_ e: Extractor) throws -> PostModel {
        return PostModel(
            id: try e <| "id",
            postedAt: try e <| "postedAt",
            user: try e <| "user",
            image: try e <| "image",
            like: try e <| "like",
            comments: try e <|| "comments"
        )
    }
}
