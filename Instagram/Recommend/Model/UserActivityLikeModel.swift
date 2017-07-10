//
//  UserActivityLikeModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct UserActivityLikeModel : UserActivityBodyModel {
    let id: Int
    let myFollowingUserId: Int
    let myFollowingUserName: String
    let myFollowingUserIcon: String
    let likedUserId: Int
    let likedUserName: String
    let likedUserIcon: String
    let postId: Int
    let likedAt: String
    let image: String
}

extension UserActivityLikeModel: Decodable {
    static func decode(_ e: Extractor) throws -> UserActivityLikeModel {
        return UserActivityLikeModel(
            id: try e <| "id",
            myFollowingUserId: try e <| "myFollowingUserId",
            myFollowingUserName: try e <| "myFollowingUserName",
            myFollowingUserIcon: try e <| "myFollowingUserIcon",
            likedUserId: try e <| "likedUserId",
            likedUserName: try e <| "likedUserName",
            likedUserIcon: try e <| "likedUserIcon",
            postId: try e <| "postId",
            likedAt: try e <| "likedAt",
            image: try e <| "image"
        )
    }
}
