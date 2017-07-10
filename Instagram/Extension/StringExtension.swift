//
//  StringExtension.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation

extension String {
    
    func toDataUTF8() -> Data {
        return self.data(using: .utf8)!
    }
}
