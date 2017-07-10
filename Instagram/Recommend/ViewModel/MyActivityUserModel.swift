//
//  MyActivityUserModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class MyActivityUserModel {
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    
    private let _blockUI = Variable<Bool>(false)
    var blockUI: Driver<Bool> {
        return _blockUI.asDriver().skip(1)
    }
    
    // TODO: tableViewのdatasourceをrxに変えるとprivateにできる
    let _activities = Variable<[MyActivityModel]>([])
    var activities: Driver<[MyActivityModel]> {
        return _activities.asDriver()
    }
    
    private let _isLoading = Variable<Bool>(false)
    var isLoading: Driver<Bool> {
        return _isLoading.asDriver().skip(1)
    }
    
    func pullTorefresh() {
        guard !self._isLoading.value else { return }
        fetchMyActivity()
    }
    
    func initialFetch() {
        guard !self._isLoading.value else { return }
        self._blockUI.value = true
        fetchMyActivity()
    }
    
    func follow(index: Int, userId: Int) {
        let myUserId = getUserId()!
        let request = FollowRequest(userId: userId, myUserId: myUserId)
        InstagramSession.send(request)
            .do(
                onSubscribe: {
                    self._isLoading.value = true },
                onDispose: {
                    self._blockUI.value = false
                    self._isLoading.value = false }
            )
            .subscribe(
                onNext: { [weak self] _ in
                    self?._activities.value[index].isFollowing = true
            }).disposed(by: disposeBag)
    }
    
    func unfollow(index: Int, userId: Int) {
        let myUserId = getUserId()!
        let request = UnfollowRequest(userId: userId, myUserId: myUserId)
        InstagramSession.send(request)
            .do(
                onSubscribe: {
                    self._isLoading.value = true },
                onDispose: {
                    self._blockUI.value = false
                    self._isLoading.value = false }
            )
            .subscribe(
                onNext: { [weak self] _ in
                    self?._activities.value[index].isFollowing = false
            }).disposed(by: disposeBag)
    }
    
    private func fetchMyActivity() {
        let userId = getUserId()!
        let request = GetMyActivityListRequest(userId: userId)
        InstagramSession.send(request)
            .do(
                onSubscribe: {
                    self._isLoading.value = true },
                onDispose: {
                    self._blockUI.value = false
                    self._isLoading.value = false }
            )
            .subscribe(
                onNext: { [weak self] response in
                    self?._activities.value = response.activities
            }).disposed(by: disposeBag)
    }
    
    private func getUserId() -> Int? {
        return realm.objects(RealmDataSet.self).first?.userId
    }
}
