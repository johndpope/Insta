//
//  LikeListsModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct LikeListsModel {
    let likes: [LikeListModel]
}

extension LikeListsModel: Decodable {
    static func decode(_ e: Extractor) throws -> LikeListsModel {
        return LikeListsModel(
            likes: try e <|| "likes"
        )
    }
}
