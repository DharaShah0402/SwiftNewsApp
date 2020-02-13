//
//  ViewController.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Swift News"
        
        viewModel.delegate = self
        viewModel.fetchNews()
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 70
        tableView?.tableFooterView = UIView()
        
        tableView.prefetchDataSource = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = viewModel.cellModel(at: indexPath)
        
        switch cellModel {
        case .newsCell(let news):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCellId", for: indexPath) as? NewsListTableViewCell else {
                    return UITableViewCell()
            }
            
            cell.articleTitle.text = news.title
            
            guard let width = news.thumbnailWidth,
                let height = news.thumbnailHeight,
                let previewUrl = news.thumbnail,
                let url = URL(string: previewUrl) else {
                    cell.thumbnailImage.isHidden = true
                    return cell
            }

            cell.loadImage(from: url, width: width, height: height, completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            })
            
            return cell
            
        case let .fullScreen(message, loading):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullScreenMessageTableViewCell", for: indexPath) as? FullScreenMessageTableViewCell else {
                return UITableViewCell()
            }

            cell.messageLabel.text = message
            cell.showLoading = loading
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = viewModel.cellModel(at: indexPath)
        switch cellModel {
        case .newsCell(_):
            return UITableView.automaticDimension
        default:
            return tableView.bounds.height
        }
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexpath -> URL?  in
            guard let news = viewModel.news(at: indexpath),
                news.thumbnailWidth != nil,
                news.thumbnailHeight != nil,
                let previewUrl = news.thumbnail,
                let url = URL(string: previewUrl) else { return nil }
            
                return url
        }
        
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        SDWebImagePrefetcher.shared.cancelPrefetching()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let news = viewModel.news(at: indexPath),
            let vc = ArticleViewController.create(with: news) else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: NewsViewModelDelegate {
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
}
