//
//  MyActivitiesModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct MyActivitiesModel {
    let activities: [MyActivityModel]
}

extension MyActivitiesModel: Decodable {
    static func decode(_ e: Extractor) throws -> MyActivitiesModel {
        return MyActivitiesModel(
            activities: try e <|| "activities"
        )
    }
}
