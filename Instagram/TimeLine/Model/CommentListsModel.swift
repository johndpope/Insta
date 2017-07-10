//
//  CommentListsModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct CommentListsModel {
    let comments: [CommentListModel]
}

extension CommentListsModel: Decodable {
    static func decode(_ e: Extractor) throws -> CommentListsModel {
        return CommentListsModel(
            comments: try e <|| "comments"
        )
    }
}
