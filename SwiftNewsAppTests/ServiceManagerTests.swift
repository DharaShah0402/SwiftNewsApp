//
//  ServiceManagerTests.swift
//  SwiftNewsAppTests
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import XCTest
@testable import SwiftNewsApp

class ServiceManagerTests: XCTestCase {
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testInValidJson() {
        let jsonString = "{\"kind\":\"Listing\",\"data\":{}}"
        let data = jsonString.data(using: .utf8)
        let networkManager = MockNetworkManager(data: data, error: nil)
        let serviceManager = MainServiceManager(networkManager: networkManager)
        
        let promise = expectation(description: "Async news testing")

        serviceManager.fetchNews { response, error in
            XCTAssertEqual(error, .unableToDecode)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testValidJson() {
        let testBundle = Bundle(for: type(of: self))

        guard let path = testBundle.path(forResource: "data", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                XCTFail("File not found")
                return
        }
        
        let networkManager = MockNetworkManager(data: data, error: nil)
        let serviceManager = MainServiceManager(networkManager: networkManager)
        
        let promise = expectation(description: "Async news testing")
        
        serviceManager.fetchNews { response, error in
            XCTAssertEqual(error, nil)
            XCTAssertNotNil(response)
            XCTAssertGreaterThan(response?.articles.count ?? 0, 0)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
}

struct MockNetworkManager: NetworkManagerDataProviding {
    let data: Data?
    let error: NetworkError?
    
    init(data: Data?, error: NetworkError?) {
        self.data = data
        self.error = error
    }
    
    func request(path: String, completion: @escaping NetworkCallCompletion) {
        completion(data,error)
    }
}
