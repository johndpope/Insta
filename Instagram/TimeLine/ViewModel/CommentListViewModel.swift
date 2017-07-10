//
//  CommentListViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit
import RealmSwift

struct CommentListViewModel {
    
    let commentLists: Variable<[CommentListModel]> = Variable<[CommentListModel]>([])
    let content: Variable<String> = Variable<String>("")
    
    let isLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private let realm = try! Realm()
    private let cellViewModel: CellViewModel = .shared
    private var disposeBag = DisposeBag()
    
    func getCommentList() {
        isLoading.value = true
        let postId = cellViewModel.tappedPostId
        let request = GetCommentListRequest(postId: postId)
        
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isLoading.value = false
            })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { resposne in
                print(resposne)
                self.commentLists.value = resposne.comments
            })
            .disposed(by: disposeBag)
    }
    
    func postComment() {
        isLoading.value = true
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let postId = cellViewModel.tappedPostId
        let content = self.content.value
        let request = PostCommentRequest(
            userId: userId!,
            postId: postId,
            content: content
        )
        
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isLoading.value = false
                self.getCommentList()
            })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { resposne in
                print(resposne)
            })
            .disposed(by: disposeBag)
    }
    
}
