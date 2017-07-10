//
//  LikeListViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit
import RealmSwift

struct LikeListViewModel {
    
    let likelists: Variable<[LikeListModel]> = Variable<[LikeListModel]>([])
    
    let isLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private let cellViewModel: CellViewModel = .shared
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    func getLikeList() {
        isLoading.value = true
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let postId = cellViewModel.tappedPostId
        let request = GetLikeListRequest(userId: userId!, postId: postId)
        
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isLoading.value = false
            })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { resposne in
                self.likelists.value = resposne.likes
            })
            .disposed(by: disposeBag)
        
    }

}
