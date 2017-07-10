//
//  UnfollowActionSheetSupport.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation

protocol UnfollowActionSheetSupport {
    
}

extension UnfollowActionSheetSupport where Self: UIViewController  {
    func presentUnfollowActionSheet(userName: String, handler: ((UIAlertAction) -> Void)?)  {
        let alert = UIAlertController(
            title: nil,
            message: "\(userName)さんのフォローをやめますか？",
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "フォローをやめる", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
