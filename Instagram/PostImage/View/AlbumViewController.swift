//
//  AlbumViewController.swift
//  Instagram
//
//  Created by 森 章人 on 2017/05/18.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AlbumViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "ライブラリ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
