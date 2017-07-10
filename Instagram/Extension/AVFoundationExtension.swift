//
//  AVFoundationExtension.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/16.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation

extension Reactive where Base: AVAsset {
    public var playable: Observable<Bool> {
        let keys = ["playable"]
        return Observable.create { observer in
            self.base.loadValuesAsynchronously(forKeys: keys) {
                observer.onNext(self.base.isPlayable)
            }
            
            return Disposables.create()
        }
    }
}

extension Reactive where Base: AVPlayerLayer {
    var ready: Observable<Void> {
        let key = "readyForDisplay"
        return observe(AnyObject.self, key, options: [], retainSelf: false)
            .map{ _ in
                Void()
            }
            .filter {
                self.base.isReadyForDisplay == true
            }
        
    }
}
