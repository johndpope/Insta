//
//  PostingImageViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct PostingImageViewModel {
    
    var imageData: Data? = nil
    var caption: Variable<String> = Variable<String>("")
    var tags: Variable<String> = Variable<String>("")
    var location: Variable<String> = Variable<String>("")
    
    let isLoading: Variable<Bool> = Variable(false)
    let error: Variable<Error?> = Variable(nil)
    
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    func postImage() {
        isLoading.value = true
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let posting = PostingImageModel(
            userId: userId!,
            imageData: self.imageData!,
            caption: self.caption.value,
            tags: self.tags.value,
            location: self.location.value
        )
        
        let postImageRequest = PostImageRequest(posting: posting)
        
        InstagramSession.send(postImageRequest)
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
    
    mutating func set(of imageData: Data) {
        self.imageData = imageData
    }
}
