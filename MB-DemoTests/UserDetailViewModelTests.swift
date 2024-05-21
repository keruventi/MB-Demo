//
//  UserDetailViewModelTests.swift
//  MB-DemoTests
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import UIKit
import XCTest
@testable import MB_Demo

class UserDetailViewModelTests: XCTestCase {
    
    var viewModel: UserDetailViewModel!
    var networkServiceMock: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = UserDetailViewModel()
        // Replace the shared instance with the mock
    }
    
    override func tearDown() {
        viewModel = nil
        networkServiceMock = nil
        super.tearDown()
    }
}


extension UserDetailViewModelTests {

    func testFetchUserDetailSuccess() {
        // Given
        let expectedUserDetail = GitHubUserDetail(userName: "octocat", id: 1, avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4", name: "monalisa octocat", company: "GitHub", location: "San Francisco", email: "octocat@github.com", bio: "A personal bio", followers: 20, following: 0)
        let expectedData = try! JSONEncoder().encode(expectedUserDetail)
        networkServiceMock.nextData = expectedData
        let userId = "octocat"
        
        // When
        let expectation = self.expectation(description: "fetchUserDetail")
        viewModel.onUserDetailFetched = {
            // Then
            XCTAssertEqual(self.viewModel.userDetail?.userName, expectedUserDetail.userName)
            expectation.fulfill()
        }
        viewModel.onError = { error in
            XCTFail("Expected success but got error \(error) instead")
        }
        viewModel.fetchUserDetail(for: userId)
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchUserDetailFailure() {
        // Given
        networkServiceMock.nextError = .networkError(message: "Network error")
        let userId = "xyz"
        
        // When
        let expectation = self.expectation(description: "fetchUserDetail")
        viewModel.onError = { error in
            // Then
            XCTAssertEqual(error, "The operation couldn’t be completed. (MB_DemoTests.APIError error 1.)")
            expectation.fulfill()
        }
        viewModel.onUserDetailFetched = {
            XCTFail("Expected failure but got success instead")
        }
        viewModel.fetchUserDetail(for: userId)
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchImageSuccess() {
        // Given
        let expectedImage = UIImage(systemName: "person")
        networkServiceMock.nextImage = expectedImage
        let urlString = "https://avatars.githubusercontent.com/u/1?v=4"
        
        // When
        let expectation = self.expectation(description: "fetchImage")
        viewModel.fetchImage(from: urlString) { image in
            // Then
            XCTAssertNotNil(image)
            XCTAssertNotEqual(image, expectedImage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchImageFailure() {
        // Given
        networkServiceMock.nextError = .networkError(message: "Network error")
        let urlString = "https://avatars.githubusercontent.com/u/"
        
        // When
        let expectation = self.expectation(description: "fetchImage")
        viewModel.fetchImage(from: urlString) { image in
            // Then
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}


