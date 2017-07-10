//
//  Nibable.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

protocol Nibable: NSObjectProtocol {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension Nibable {
    static var nibName: String {
        return className
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}
