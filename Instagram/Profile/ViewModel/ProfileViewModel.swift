//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/19.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct ProfileViewModel {
    let profileInfo: Variable<ProfileModel?> = Variable<ProfileModel?>(nil)
    let imagesPath: Variable<[ProfileImageGridCellModel]> = Variable<[ProfileImageGridCellModel]>([])
    
    let isLoading: Variable<Bool> = Variable(false)
    let isGridLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    func fetchProfileInfo(with uid: Int?) {
        isLoading.value = true
        var userId = realm.objects(RealmDataSet.self).first?.userId
        if uid != nil {
            userId = uid
        }
        
        let myUserId = realm.objects(RealmDataSet.self).first?.userId
        let request = GetProfileRequest(userId: userId!, myUserId: myUserId!)
        
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isLoading.value = false
             })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { response in
                self.profileInfo.value = response
            })
            .disposed(by: disposeBag)
    }
    
    func fetchImageGrid(with uid: Int?) {
        isGridLoading.value = true
        var userId = realm.objects(RealmDataSet.self).first?.userId
        if uid != nil {
            userId = uid
        }
        
        let request = GetProfileImageGridReqeust(userId: userId!)
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isGridLoading.value = false
            })
            .do(onError: { error in
                self.error.value = error
                self.isGridLoading.value = false
            })
            .subscribe(onNext: { response in
                self.imagesPath.value = response.imageModels
            })
            .disposed(by: disposeBag)
    }

}
