//
//  PostingStoryVideoViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct PostingStoryVideoViewModel {
    
    var videoData: Data? = nil
    
    let isLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    func postStoryVideo() {
        isLoading.value = true
        
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let postStoryVideoRequest = PostStoryVideoRequest(
            userId: userId!,
            videoData: self.videoData!
        )
        
        InstagramSession.send(postStoryVideoRequest)
            .do(onCompleted: { _ in
                self.isLoading.value = false
            })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { response in
                
            }, onError: { error in
                print("Error in postImage")
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    mutating func set(of videoData: Data) {
        self.videoData = videoData
    }
}
