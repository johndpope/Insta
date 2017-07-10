//
//  Storyboardable.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return className
    }
    
    static func instantiate() -> Self {
        return UIStoryboard(name: storyboardName, bundle: .main).instantiateInitialViewController() as! Self
    }
}

extension Storyboardable where Self: UIViewController {
    static func instantiateWithNavigationController(with id: String) -> UINavigationController {
        let vc = UIStoryboard(name: storyboardName, bundle: .main).instantiateViewController(withIdentifier: id) as! Self
        let navVC = UINavigationController(rootViewController: vc)
        return navVC
    }
}
