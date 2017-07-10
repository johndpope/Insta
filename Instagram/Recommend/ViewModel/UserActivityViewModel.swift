//
//  UserActivityViewModel.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/26.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import SVProgressHUD

class UserActivityViewModel {
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    
    private let _blockUI = Variable<Bool>(false)
    var blockUI: Driver<Bool> {
        return _blockUI.asDriver().skip(1)
    }
    
    // TODO: tableViewのdatasourceをrxに変えるとprivateにできる
    let _activities = Variable<[UserActivityModel]>([])
    var activities: Driver<[UserActivityModel]> {
        return _activities.asDriver()
    }
    
    private let _isLoading = Variable<Bool>(false)
    var isLoading: Driver<Bool> {
        return _isLoading.asDriver().skip(1)
    }
    
    func pullTorefresh() {
        guard !self._isLoading.value else { return }
        fetchUserActivity()
    }
    
    func initialFetch() {
        guard !self._isLoading.value else { return }
        self._blockUI.value = true
        fetchUserActivity()
    }
    
    private func fetchUserActivity() {
        let userId = getUserId()!
        let request = GetFollowingUserActivityListRequest(userId: userId)
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
