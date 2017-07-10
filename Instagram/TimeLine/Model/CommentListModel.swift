//
//  CommentListModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct CommentListModel {
    let userId: Int
    let content: String
    let name: String
    let icon: String
    let commentedAt: String
}

extension CommentListModel: Decodable {
    static func decode(_ e: Extractor) throws -> CommentListModel {
        return CommentListModel(
            userId: try e <| "userId",
            content: try e <| "content",
            name: try e <| "name",
            icon: try e <| "icon",
            commentedAt: try e <| "commentedAt"
        )
    }
}
