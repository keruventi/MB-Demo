//
//  UsersViewModelTests.swift
//  MB-DemoTests
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import XCTest
@testable import MB_Demo

class UsersViewModelTests: XCTestCase {
    
    var viewModel: UsersViewModel!
    var networkServiceMock: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        viewModel = UsersViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        networkServiceMock = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() {
        let expectedUser = GitHubUser(id: 1, userId: "mojombo",  avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4")
        let expectedData = try! JSONEncoder().encode([expectedUser])
        networkServiceMock.nextData = expectedData
        
        let expectation = self.expectation(description: "FetchUsers")
        viewModel.onUsersFetched = {
            XCTAssertEqual(self.viewModel.users.count, 20)
            XCTAssertEqual(self.viewModel.users.first?.userId, "mojombo")
            expectation.fulfill()
        }
        
        viewModel.fetchUsers()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchUsersFailure() {
//        networkServiceMock.nextError = .networkError(message: "Network error")
//        
//        let expectation = self.expectation(description: "FetchUsers")
//        viewModel.onError = { error in
//            XCTAssertEqual(error, "The operation couldn’t be completed. (NetworkError error 1.)")
//            expectation.fulfill()
//        }
//        
//        viewModel.fetchUsers()
//        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func testFetchImageSuccess() {
        // Given
        let expectedImage = UIImage(systemName: "person")
        networkServiceMock.nextImage = expectedImage
        let urlString = "https://avatars.githubusercontent.com/u/583231?v=4"
        
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
