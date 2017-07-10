//
//  WorldImageTimeLineViewModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/19.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation
import RealmSwift

struct WorldImageTimeLineViewModel {
    let stories: Variable<[StoryModel]> = Variable<[StoryModel]>([])
    let posts: Variable<[PostModel]> = Variable<[PostModel]>([])
    let storyVideos: Variable<[StoryVideoModel?]> = Variable<[StoryVideoModel?]>([])
    let storyImages: Variable<[URL?]> = Variable<[URL?]>([])
    let storyTypes: Variable<[StoryType]> = Variable<[StoryType]>([])
    
    let isLoading: Variable<Bool> = Variable(false)
    let isVideoLoading: Variable<Bool> = Variable(false)
    let untilId: Variable<Int> = Variable(0)
    
    let error: Variable<Error?> = Variable(nil)
    
    private let realm = try! Realm()
    private var disposeBag = DisposeBag()
    
    func fetchTimeLine() {
        isLoading.value = true
        
        let userId = realm.objects(RealmDataSet.self).first?.userId
        let limit = 5
        let request = GetMyTimeLineRequest(userId: userId!, limit: limit)
        
        InstagramSession.send(request)
            .do(onCompleted: { _ in
                self.isLoading.value = false
            })
            .do(onError: { error in
                self.error.value = error
                self.isLoading.value = false
            })
            .subscribe(onNext: { response in
                self.stories.value = response.stories
                self.posts.value = response.posts
                self.untilId.value = (response.posts.last?.id)!
                
                var videos: [StoryVideoModel?] = []
                var images: [URL?] = []
                for storyModel in self.stories.value {
                    if let videoStory = storyModel.videoStory {
                        let url = URL(string: videoStory)!
                        videos.append(StoryVideoModel(url: url))
                        self.storyTypes.value.append(.video)
                    } else {
                        videos.append(nil)
                    }
                    
                    if let imageStory = storyModel.imageStory {
                        let url = URL(string: imageStory)!
                        images.append(url)
                        self.storyTypes.value.append(.image)
                    } else {
                        images.append(nil)
                    }
                }
                self.storyVideos.value = videos
                self.storyImages.value = images
                CellViewModel.shared.likedPostIdSet = Set()
                CellViewModel.shared.dislikedPostIdSet = Set()
            })
            .disposed(by: disposeBag)
    }

}
