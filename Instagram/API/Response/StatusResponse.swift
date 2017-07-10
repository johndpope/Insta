//
//  StatusResponse.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import Himotoki

struct StatusResponse {
    let status: String
}

extension StatusResponse: Decodable {
    static func decode(_ e: Extractor) throws -> StatusResponse {
        return StatusResponse(
            status: try e <| "status"
        )
    }
}
