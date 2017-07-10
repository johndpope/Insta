//
//  UserActivityModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct UserActivitiesModel {
    let activities: [UserActivityModel]
}

extension UserActivitiesModel: Decodable {
    static func decode(_ e: Extractor) throws -> UserActivitiesModel {
        return UserActivitiesModel(
            activities: try e <|| "activities"
        )
    }
}
