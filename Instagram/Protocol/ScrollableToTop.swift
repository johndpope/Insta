//
//  ScrollableToTop.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/29.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

protocol ScrollableToTop {
    func scrollToTop()
}

extension ScrollableToTop {
    func scrollToTop(_ scrollView: UIScrollView) {
        let offset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        scrollView.setContentOffset(offset, animated: true)
    }
}
