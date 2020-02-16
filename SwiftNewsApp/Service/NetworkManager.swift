//
//  ServiceManager.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.

import Foundation
import UIKit

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case delete  = "DELETE"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
}

public enum NetworkError : String, Error {
    case badRequestError
    case networkError
}

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

public typealias NetworkCallCompletion = (_ data: Data?, _ error: NetworkError?) -> ()

protocol NetworkManagerDataProviding {
    func request(path: String, completion: @escaping NetworkCallCompletion)
}

class NetworkManager: NetworkManagerDataProviding {
    let baseUrl: String = "https://www.reddit.com/"
    
    var urlSession: URLSession  {
        return URLSession.shared
    }
    
    var defaultSession: URLSession {
       return URLSession(configuration: .default)
    }

    func request(path: String, completion: @escaping NetworkCallCompletion) {
                
        let mainURL = URL(string: baseUrl + path)
        guard let url = mainURL else { return }
                
        let task = defaultSession.dataTask(with: url, completionHandler: {  data, response, error in
            DispatchQueue.main.async {
                
                if error == nil, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                    completion(data, nil)
                    return
                }
                
                completion(data, NetworkError.networkError)
            }
        })
        
        task.resume()
        
    }
}


