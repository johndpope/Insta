//
//  PostImageModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct PostImageModel {
    let url: String
    let location: String?
    let width: Int
    let height: Int
}

extension PostImageModel: Decodable {
    static func decode(_ e: Extractor) throws -> PostImageModel {
        return PostImageModel(
            url: try e <| "url",
            location: try e <|? "location",
            width: try e <| "width",
            height: try e <| "height"
        )
    }
}
