//
//  MyActivityModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct MyActivityModel {
    let id: Int
    let myFollowingUserId: Int
    let myFollowingUserName: String
    let myFollowingUserIcon: String
    let followedAt: String
    var isFollowing: Bool
}

extension MyActivityModel: Decodable {
    static func decode(_ e: Extractor) throws -> MyActivityModel {
        return MyActivityModel(
            id: try e <| "id",
            myFollowingUserId: try e <| "myFollowingUserId",
            myFollowingUserName: try e <| "myFollowingUserName",
            myFollowingUserIcon: try e <| "myFollowingUserIcon",
            followedAt: try e <| "followedAt",
            isFollowing: try e <| "isFollowing"
        )
    }
}
