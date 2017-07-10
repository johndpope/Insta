//
//  ProfileImageGridCellModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct ProfileImageGridCellModel {
    let postId: Int
    let imagePath: String
    let postedAt: String
}


extension ProfileImageGridCellModel: Decodable {
    static func decode(_ e: Extractor) throws -> ProfileImageGridCellModel {
        return ProfileImageGridCellModel(
            postId: try e <| "postId",
            imagePath: try e <| "image",
            postedAt: try e <| "postedAt"
        )
    }
}
