//
//  MyProfileOptionController.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import UIKit

final class MyProfileOptionViewController: UIViewController, Storyboardable {
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "オプション"
    }
}
