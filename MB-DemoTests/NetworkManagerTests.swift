//
//  NetworkManagerTests.swift
//  MB-DemoTests
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import XCTest
@testable import MB_Demo

class NetworkManagerTests: XCTestCase {

    var networkService: NetworkService!
    var urlSessionMock: URLSessionMock!

    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
        networkService = NetworkService.shared
    }

    override func tearDown() {
        networkService = nil
        urlSessionMock = nil
        super.tearDown()
    }

    func testFetchUsersSuccess() {
        let expectedData = """
        [
            {"login": "mojombo", "id": 1, "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4", "url": "https://api.github.com/users/mojombo"}
        ]
        """.data(using: .utf8)!

        urlSessionMock.data = expectedData
        let expectation = self.expectation(description: "FetchUsers")

        networkService.fetchData(from: .fetchUsers(perPage: 10, since: 0), completion: { (result: Result<[GitHubUser], APIError>) in
            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 10)
                XCTAssertEqual(users.first?.userId, "mojombo")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchUserDetailSuccess() {
        let expectedData = """
        {
            "login": "mojombo",
            "id": 1,
            "node_id": "MDQ6VXNlcjE=",
            "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
            "name": "Tom Preston-Werner",
            "company": "@chatterbugapp, @redwoodjs, @preston-werner-ventures ",
            "location": "San Francisco",
            "email": null,
            "bio": null,
            "followers": 23874,
            "following": 11,
            "updated_at": "2024-05-09T20:21:24Z"
        }
        """.data(using: .utf8)!

        urlSessionMock.data = expectedData
        let requestType = RequestType.fetchUserDetail(userId: "mojombo")
        let expectation = self.expectation(description: "FetchUserDetail")

        networkService.fetchData(from: requestType) { (result: Result<GitHubUserDetail, APIError>) in
            switch result {
            case .success(let userDetail):
                XCTAssertEqual(userDetail.userName, "mojombo")
                XCTAssertEqual(userDetail.name, "Tom Preston-Werner")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchUserDetailFailure() {
        urlSessionMock.error = APIError.invalidData
        let requestType = RequestType.fetchUserDetail(userId: "")
        let expectation = self.expectation(description: "FetchUserDetail")

        networkService.fetchData(from: requestType) { (result: Result<GitHubUserDetail, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, .networkError(message: "Not Found"))
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

