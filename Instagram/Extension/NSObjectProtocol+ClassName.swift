//
//  NSObject+ClassName.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
