//
//  EditMyProfileViewController.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import UIKit

class EditMyProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        let cancel = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        let complete = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.completeButtonTapped))
        self.navigationItem.setLeftBarButton(cancel, animated: true)
        self.navigationItem.setRightBarButton(complete, animated: true)
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    func completeButtonTapped() {
        dismiss(animated: true)
    }
}
