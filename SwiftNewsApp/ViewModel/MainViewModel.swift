//
//  MainViewModel.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation

enum NewsCellModel {
    case fullScreen(message: String, loading: Bool)
    case newsCell(news: Article)
}

protocol NewsViewModelDelegate {
    func updateView()
}

class MainViewModel {
    
    private let serviceManager: MainServiceManagerDataProviding
    private var loadingState: LoadingState = .loading
    var delegate: NewsViewModelDelegate?
    private var news: [Article]?
    
    enum LoadingState {
        case loading
        case error(message: String)
        case empty
        case completed
    }
    
    init(serviceManager: MainServiceManagerDataProviding = MainServiceManager()) {
        self.serviceManager = serviceManager
    }
    
    var numberOfRows: Int {
        switch self.loadingState {
        case .loading, .error, .empty:
            return 1
        default:
            return news?.count ?? 0
        }
    }
    
    func news(at indexPath: IndexPath) -> Article? {
        guard case .completed = self.loadingState else { return nil}
        
        return self.news?[indexPath.row]
    }
    
    func cellModel(at indexPath: IndexPath) -> NewsCellModel {
        switch self.loadingState {
        case .completed:
            guard let news = news?[indexPath.row] else {
                return .fullScreen(message: "Something went wrong", loading: false)
            }
            return .newsCell(news: news)
        case .empty:
            return .fullScreen(message: "List is empty", loading: false)
        case .loading:
            return .fullScreen(message: "Loading news...", loading: true)
        case .error(let errorDescription):
            return .fullScreen(message: errorDescription, loading: false)
        }
    }
    
    func fetchNews(completion: (() -> Void)? = nil) {
        self.loadingState = .loading
        serviceManager.fetchNews { [weak self]  response, error in
            guard error == nil, let news = response?.articles else {
                self?.loadingState = .error(message: error?.description ?? "Something went wrong")
                self?.delegate?.updateView()
                completion?()
                return
            }
            
            self?.loadingState = news.count > 0 ? .completed : .empty
            self?.news = news
            self?.delegate?.updateView()
            completion?()
        }
    }
}
