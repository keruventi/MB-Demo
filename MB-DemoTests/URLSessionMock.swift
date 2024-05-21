//
//  URLSessionMock.swift
//  MB-DemoTests
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import XCTest
@testable import MB_Demo

class URLSessionMock: URLSession {
    var data: Data?
    var error: APIError?
    var response: URLResponse?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = self.response
        
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
