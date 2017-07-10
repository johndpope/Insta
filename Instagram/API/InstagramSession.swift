//
//  InstagramSession.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import APIKit
import RxSwift
import RxCocoa
import Result


struct InstagramSession {
    
    static func send<T: InstagramRequest>(_ request: T) -> Observable<T.Response> {
        let observable = Observable<T.Response>.create { observer in
            let task = Session.send(request, callbackQueue: .main, handler: { result in
                switch result {
                case .success(let value):
                    observer.on(.next(value))
                    observer.onCompleted()
                    
                case .failure(let error):
                    if (error as NSError).code == URLError.cancelled.rawValue {
                        observer.onCompleted()
                        break
                    }
                    observer.onError(error)
                }
            })
            return Disposables.create(with: {
                task?.cancel()
            })
        }
        return observable.take(1)

    }
    
    static func cancelRequest<T: Request>(with type: T.Type) {
        Session.cancelRequests(with: type)
    }

}
