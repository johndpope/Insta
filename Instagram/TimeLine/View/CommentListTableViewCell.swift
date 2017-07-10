//
//  CommentListTableViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

class CommentListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with list: CommentListModel) {
        iconImageView.kf.cancelDownloadTask()
        let url = URL(string: list.icon)!
        iconImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2.0
        iconImageView.clipsToBounds = true
        
        userNameLabel.text = list.name
        contentLabel.text = list.content
    }
    
}
