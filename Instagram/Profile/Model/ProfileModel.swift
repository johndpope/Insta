//
//  profileModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/19.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct ProfileModel {
    let name: String
    let icon: String
    let followingCount: Int
    let followerCount: Int
    let postCount: Int
    let isFollowing: Bool
}


extension ProfileModel: Decodable {
    static func decode(_ e: Extractor) throws -> ProfileModel {
        return ProfileModel(
            name: try e <| "name",
            icon: try e <| "icon",
            followingCount: try e <| "followCount",
            followerCount: try e <| "followerCount",
            postCount: try e <| "postCount",
            isFollowing: try e <| "isFollowing"
        )
    }
}
