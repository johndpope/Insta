//
//  LikeListTableViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import Kingfisher

class LikeListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with list: LikeListModel) {
        iconImageView.kf.cancelDownloadTask()
        let url = URL(string: list.icon)!
        iconImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2.0
        iconImageView.clipsToBounds = true
        
        userNameLabel.text = list.name
        followButton.layer.cornerRadius = 2
        followButton.clipsToBounds = true
        
        if list.isFollowing {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    private func configureFollowButton() {
        followButton.setTitle("フォローする", for: .normal)
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.backgroundColor = UIColor(red: 0, green: 128.0/255.0, blue: 1.0, alpha: 1.0)
        followButton.layer.borderWidth = 0
    }
    
    private func configureUnFollowButton() {
        followButton.setTitle("フォロー中", for: .normal)
        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
