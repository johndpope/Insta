//
//  WorldImageCollectionViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/19.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

class WorldImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var worldImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with post: PostModel) {
        worldImageView.kf.cancelDownloadTask()
        let imageURL = URL(string: post.image.url)
        worldImageView.kf.setImage(with: imageURL!, options: [.transition(.fade(0.3))])
    }
}
