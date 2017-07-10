//
//  CellViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/17.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class CellViewModel {
    static let shared = CellViewModel()
    
    let isLikeList: Variable<Bool> = Variable<Bool>(false)
    let isCommentList: Variable<Bool> = Variable<Bool>(false)
    
    var tappedPostId: Int = 0
    var dislikedPostIdSet: Set<Int> = Set()
    var likedPostIdSet: Set<Int> = Set()
    
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    private init() {}
    
    
    func postLike(with postId: Int) {
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let request = PostLikeRequest(userId: userId!, postId: postId)
        InstagramSession.send(request)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
            })
            .disposed(by: disposeBag)
    }
    
    func postDislike(with postId: Int) {
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let request = PostDislikeRequest(userId: userId!, postId: postId)
        InstagramSession.send(request)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
            })
            .disposed(by: disposeBag)
    }
}
