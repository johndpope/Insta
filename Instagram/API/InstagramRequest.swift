//
//  InstagramRequest.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import APIKit
import Himotoki


protocol InstagramRequest: Request {
}

extension InstagramRequest {
    var baseURL: URL {
        //let urlString = "https://private-31d2a93-team15api1.apiary-mock.com"
        let urlString = "http://35.187.220.27"
        //let urlString = "http://127.0.0.1:8080"
        return URL(string: urlString)!
    }
    
    // Timeout
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        
        var _urlRequest = urlRequest
        
        switch self.method {
        case .post, .put, .delete:
            _urlRequest.timeoutInterval = 20.0
        default:
            _urlRequest.timeoutInterval = 20.0
        }
        
        return _urlRequest
    }
    
    /*
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        // convert ErrorResponseBody
        guard (200..<300).contains(urlResponse.statusCode) else {
            guard let errorBody: [String: Any] = object as? [String: Any] else { return object }
            guard let response: [String: Any] = errorBody["response"] as? [String: Any] else { return object }
            guard let error: [String: Any] = response["error"] as? [String: Any] else { return object }
            guard let message: String = error["message"] as? String else { return object }
            let type: String? = error["type"] as? String
            throw ErrorResponseBody(message: message, type: type, statusCode: urlResponse.statusCode, endPoint: urlResponse.url)
        }
        
        return object
    }*/
}

extension InstagramRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
