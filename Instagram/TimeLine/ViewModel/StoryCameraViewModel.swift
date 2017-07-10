//
//  StoryCameraViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

enum CameraStatus {
    case normal
    case live
}

class StoryCameraViewModel {
    let normal: StoryNormalCameraModel?
    let live: StoryLiveCameraModel?
    private var currentStatus: CameraStatus = .normal
    
    
    let isLoading: Variable<Bool> = Variable<Bool>(false)
    let error: Variable<Error?> = Variable<Error?>(nil)
    let path: Variable<String> = Variable<String>("")
    let key: Variable<String> = Variable<String>("")
    
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    
    init(screenWidth: CGFloat, coreWidth: CGFloat, currentGap: CGFloat) {
        normal = StoryNormalCameraModel(
            buttonWidth: coreWidth,
            gap: currentGap
        )
        live = StoryLiveCameraModel(
            buttonWidth: screenWidth * 0.7,
            gap: currentGap * 0.3
        )
    }
    
    func getCurrentStatus() -> CameraStatus {
        return self.currentStatus
    }
    
    func changeStatus() {
        if self.currentStatus == .normal {
            self.currentStatus = .live
        } else if self.currentStatus == .live {
            self.currentStatus = .normal
        }
    }
    
    func prepareForLive() {
        isLoading.value = true
        
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let request = PostStoryLiveVideoRequest(userId: userId!)
        
        InstagramSession.send(request)
            .do(onCompleted: { [unowned self] _ in
                self.isLoading.value = false
            })
            .do(onError: { [unowned self] error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { [unowned self] response in
                self.path.value = response.path
                self.key.value = response.key
            })
            .disposed(by: disposeBag)

    }
}
