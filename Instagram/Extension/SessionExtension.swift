//
//  SessionExtension.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/12.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import APIKit
import RxSwift

extension Session {
    public static func rx_response<T: Request>(_ request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = send(request) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .failure(let error):
                    // TODO: Add Error Logger
                    print("\(error)")
                    switch error {
                    case .connectionError(let connectionError as NSError):
                        switch connectionError.code {
                        case -1001:
                            break
                            // TODO: if timeout
                        //                            observer.onError(DataStoreError.failRequestTimeout)
                        default:
                            // TODO:
                            //                            observer.onError(DataStoreError.failGetRequest)
                            break
                        }
                    case .responseError(let error):
                        observer.onError(error)
                    default:
                        observer.onError(error)
                    }
                }
            }
            let t = task
            t?.resume()
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
