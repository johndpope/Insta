//
//  PostUserModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct PostUserModel {
    let id: Int
    let name: String
    let iconURL: String
}

extension PostUserModel: Decodable {
    static func decode(_ e: Extractor) throws -> PostUserModel {
        return PostUserModel(
            id: try e <| "id",
            name: try e <| "name",
            iconURL: try e <| "icon"
        )
    }
}
