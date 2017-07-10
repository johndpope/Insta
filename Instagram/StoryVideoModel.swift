//
//  StoryVideoModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/16.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import AVFoundation

struct StoryVideoModel {
    let asset: AVURLAsset
    let playerItem: AVPlayerItem
    let player: AVPlayer?
    
    init(url: URL) {
        self.asset = AVURLAsset(url: url)
        self.playerItem = AVPlayerItem(asset: self.asset)
        self.player = AVPlayer(playerItem: self.playerItem)
    }
}
