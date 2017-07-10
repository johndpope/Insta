//
//  LikeListModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct LikeListModel {
    let userId: Int
    let name: String
    let icon: String
    let isFollowing: Bool
}

extension LikeListModel: Decodable {
    static func decode(_ e: Extractor) throws -> LikeListModel {
        return LikeListModel(
            userId: try e <| "userId",
            name: try e <| "name",
            icon: try e <| "icon",
            isFollowing: try e <| "isFollowing"
        )
    }
}
