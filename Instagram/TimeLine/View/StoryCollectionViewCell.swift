//
//  StoryCollectionViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/11.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import Kingfisher

class StoryCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var heightCoefficient: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with story: StoryModel) {
        userImageView.kf.cancelDownloadTask()
        let imageURL = URL(string: story.userIconURL)
        userNameLabel.text = story.userName
        userImageView.kf.setImage(with: imageURL!, options: [.transition(.fade(0.3))])
        userImageView.layer.cornerRadius = bounds.height * 0.7 / 2
        userImageView.clipsToBounds = true
    }
}
