//
//  UIScrollViewExtension.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/25.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIScrollView {
    var reachedBottom: Observable<Void> {
        return contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Bool> in
                guard let scrollView = base else {
                    return Observable.empty()
                }
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                return  Observable.just(y > threshold)
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
    }
}
