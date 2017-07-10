//
//  UserActivityModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct UserActivityModel {
    let type: String
    let body: UserActivityBodyModel
}

extension UserActivityModel: Decodable {
    static func decode(_ e: Extractor) throws -> UserActivityModel {
        let type: String = try e <| "type"
        let body = try { () -> UserActivityBodyModel in
            if type == "follow" {
                let follow: UserActivityFollowModel = try e <| "body"
                return follow
            } else {
                let like: UserActivityLikeModel = try e <| "body"
                return like
            }
        }()
        return UserActivityModel(
            type: type,
            body: body
        )
    }
}
