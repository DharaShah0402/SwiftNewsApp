//
//  MainViewModelTests.swift
//  SwiftNewsAppTests
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import XCTest
@testable import SwiftNewsApp

class MainViewModelTests: XCTestCase {
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testInitialStatus() {
        let mockServiceManager = MockSwiftNewsServiceManager(response: nil, error: nil)
        let viewModel = MainViewModel(serviceManager: mockServiceManager)
        XCTAssertTrue(viewModel.numberOfRows == 1)
    }
    
    func testErrorStatus() {
        let mockServiceManager = MockSwiftNewsServiceManager(response: nil, error: NewsServiceError.unableToDecode)
        let viewModel = MainViewModel(serviceManager: mockServiceManager)
        
        let promise = expectation(description: "Async news testing")

        viewModel.fetchNews {
            XCTAssertTrue(viewModel.numberOfRows == 1)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testEmptyStatus() {
        let response = SwiftResponse(articles: [])
        let mockServiceManager = MockSwiftNewsServiceManager(response: response, error: nil)
        let viewModel = MainViewModel(serviceManager: mockServiceManager)
        let promise = expectation(description: "Async news testing")

        viewModel.fetchNews {
            XCTAssertTrue(viewModel.numberOfRows == 1)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testCompletedStatus() {
        let response = SwiftResponse.createMockResponse()
        let mockServiceManager = MockSwiftNewsServiceManager(response: response, error: nil)
        let viewModel = MainViewModel(serviceManager: mockServiceManager)
        let promise = expectation(description: "Async news testing")
        
        viewModel.fetchNews {
            XCTAssertTrue(viewModel.numberOfRows == 2)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}

struct MockSwiftNewsServiceManager:  MainServiceManagerDataProviding {
    let response: SwiftResponse?
    let error: NewsServiceError?
    
    init(response: SwiftResponse?, error: NewsServiceError?) {
        self.response = response
        self.error = error
    }
    
    func fetchNews(completion: @escaping (SwiftResponse?, NewsServiceError?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(self.response, self.error)
        }
    }
}

extension SwiftResponse {
    public static func createMockResponse() -> SwiftResponse {
        return SwiftResponse(articles: Article.createMockArticles())
    }
}


extension Article {
    public static func createMockArticles() -> [Article] {
        let article1 = Article(title: "News1",
                               body: "Body1",
                               thumbnailWidth: nil,
                               thumbnailHeight: nil,
                               thumbnail: nil)
        
        let article2 = Article(title: "News2",
                               body: "Body2",
                               thumbnailWidth: nil,
                               thumbnailHeight: nil,
                               thumbnail: nil)
        
        return [article1, article2]
        
    }
}
