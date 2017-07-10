//
//  MyActivityTableViewCell.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import ActiveLabel

class MyActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var label: ActiveLabel!
    @IBOutlet weak var button: UIButton!
    
    func configure(_ model: MyActivityModel) {
        configureUserIcon(model)
        configureLabel(model)
        configureButton(model)
    }
    
    func configureUserIcon(_ model: MyActivityModel) {
        userIcon.kf.setImage(with: URL(string: model.myFollowingUserIcon), options: [.transition(.fade(0.3))])
        userIcon.layer.cornerRadius = userIcon.frame.size.height / 2
        userIcon.clipsToBounds = true
        userIcon.layer.borderColor = UIColor.gray.cgColor;
        userIcon.layer.borderWidth = 0.5;
    }
    
    func configureLabel(_ model: MyActivityModel) {
        let dateString = Date.ISO8601(optionalString: model.followedAt)?.toStringDate() ?? ""
        
        let fromUserType = ActiveType.custom(pattern: "\(model.myFollowingUserName)さん")
        let dateType = ActiveType.custom(pattern: dateString)
        label.enabledTypes = [fromUserType, dateType]
        label.configureLinkAttribute = { type, attributes, isSelected in
            var atts = attributes
            if case fromUserType = type {
                atts[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 15)
            }
            if case dateType = type {
                atts[NSForegroundColorAttributeName] = UIColor.gray
                atts[NSFontAttributeName] = UIFont.systemFont(ofSize: 14)
            }
            
            return atts
        }
        label.handleCustomTap(for: fromUserType) { element in
            print("fromUser")
        }

        
        let message = "\(model.myFollowingUserName)さんがあなたをフォローしました。　\(dateString)"
        label.text = message
    }
    
    func configureButton(_ model: MyActivityModel) {
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        if model.isFollowing {
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setTitle("フォロー中", for: .normal)
        } else {
            button.backgroundColor = UIColor.hex("#0079FF", alpha: 1.0)
            button.layer.borderColor = button.backgroundColor?.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle("フォローする", for: .normal)
        }
    }
}
