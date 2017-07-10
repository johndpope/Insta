//
//  PostCommentModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct PostCommentModel {
    let userId: Int
    let userName: String
    let content: String
}

extension PostCommentModel: Decodable {
    static func decode(_ e: Extractor) throws -> PostCommentModel {
        return PostCommentModel(
            userId: try e <| "userId",
            userName: try e <| "userName",
            content: try e <| "content"
        )
    }
}
