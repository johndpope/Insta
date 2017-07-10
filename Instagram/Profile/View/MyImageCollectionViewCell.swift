//
//  MyImageCollectionViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import Kingfisher

class MyImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with gridCell: ProfileImageGridCellModel) {
        //self.frame.size.height = 100
        imageView.kf.cancelDownloadTask()
        let imageURL = URL(string: gridCell.imagePath)
        imageView.kf.setImage(with: imageURL!, options: [.transition(.fade(0.3))])
    }
}
