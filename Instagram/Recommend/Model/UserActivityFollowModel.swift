//
//  UserActivityFollowModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct UserActivityFollowModel : UserActivityBodyModel {
    let id: Int
    let myFollowingUserId: Int
    let myFollowingUserName: String
    let myFollowingUserIcon: String
    let followedUserId: Int
    let followedUserName: String
    let followedUserIcon: String
    let followedAt: String
}

extension UserActivityFollowModel: Decodable {
    static func decode(_ e: Extractor) throws -> UserActivityFollowModel {
        return UserActivityFollowModel(
            id: try e <| "id",
            myFollowingUserId: try e <| "myFollowingUserId",
            myFollowingUserName: try e <| "myFollowingUserName",
            myFollowingUserIcon: try e <| "myFollowingUserIcon",
            followedUserId: try e <| "followedUserId",
            followedUserName: try e <| "followedUserName",
            followedUserIcon: try e <| "followedUserIcon",
            followedAt: try e <| "followedAt"
        )
    }
}
