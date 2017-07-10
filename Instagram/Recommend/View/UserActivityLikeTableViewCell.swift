//
//  UserActivityLikeTableViewCell.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/25.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import ActiveLabel

class UserActivityLikeTableViewCell: UITableViewCell {
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var label: ActiveLabel!
    @IBOutlet weak var postImage: UIImageView!
    
    func configure(_ model: UserActivityLikeModel) {
        configureUserIcon(model)
        configureLabel(model)
        configurePostImage(model)
    }
    
    func configureUserIcon(_ model: UserActivityLikeModel) {
        userIcon.kf.setImage(with: URL(string: model.myFollowingUserIcon), options: [.transition(.fade(0.3))])
        userIcon.layer.cornerRadius = userIcon.frame.size.height / 2
        userIcon.clipsToBounds = true
        userIcon.layer.borderColor = UIColor.gray.cgColor;
        userIcon.layer.borderWidth = 0.5;
    }
    
    func configureLabel(_ model: UserActivityLikeModel) {
        let dateString = Date.ISO8601(optionalString: model.likedAt)?.toStringDate() ?? ""
        
        let fromUserType = ActiveType.custom(pattern: "\(model.myFollowingUserName)さん")
        let toUserType = ActiveType.custom(pattern: "\(model.likedUserName)さん")
        let dateType = ActiveType.custom(pattern: dateString)
        label.enabledTypes = [fromUserType, toUserType, dateType]
        label.configureLinkAttribute = { type, attributes, isSelected in
            var atts = attributes
            if case fromUserType = type {
                atts[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 15)
            }
            if case toUserType = type {
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
        label.handleCustomTap(for: toUserType) { element in
            print("toUser")
        }
        
        let message = "\(model.myFollowingUserName)さんが\(model.likedUserName)さんの投稿にいいねしました。 \(dateString)"
        label.text = message
    }
    
    func configurePostImage(_ model: UserActivityLikeModel) {
        postImage.kf.setImage(with: URL(string: model.image), options: [.transition(.fade(0.3))])
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if self == hitView {
            return nil
        } else {
            return hitView
        }
    }
}
