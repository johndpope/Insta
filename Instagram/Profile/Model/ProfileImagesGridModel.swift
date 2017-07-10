//
//  ProfileImageGridModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct ProfileImagesGridModel {
    let imageModels: [ProfileImageGridCellModel]
}


extension ProfileImagesGridModel: Decodable {
    static func decode(_ e: Extractor) throws -> ProfileImagesGridModel {
        return ProfileImagesGridModel(
            imageModels: try e <|| "images"
        )
    }
}
