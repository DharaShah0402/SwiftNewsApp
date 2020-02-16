//
//  MainServiceManager.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation

enum NewsServiceError {
    case noData
    case unableToDecode
    case general
    
    var description: String {
        switch self {
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .general:
            return "Network Error"
        }
    }
}

protocol MainServiceManagerDataProviding {
    func fetchNews(completion: @escaping (SwiftResponse?, NewsServiceError?) -> Void)
}

struct MainServiceManager: MainServiceManagerDataProviding {
    let networkManager: NetworkManagerDataProviding
    
    init(networkManager: NetworkManagerDataProviding = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchNews(completion: @escaping (SwiftResponse?, NewsServiceError?) -> Void) {
        networkManager.request(path: "r/swift/.json") { data, _ in
            guard let data = data else {
                completion(nil, .general)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let news = try decoder.decode(SwiftResponse.self, from: data)
                completion(news, nil)
            } catch {
                completion(nil, .unableToDecode)
            }
        }
    }
}
