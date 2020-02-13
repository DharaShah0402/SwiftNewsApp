//
//  ArticleViewController.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SDWebImage

class ArticleViewController: UIViewController {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var textContainerView: UITextView!
    var article: Article?
    
    static func create(with article: Article) -> ArticleViewController? {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleViewController else { return nil }
        viewController.article = article
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = article?.title
        setupUI()
    }
    
    func setupUI() {
        self.textContainerView.text = article?.body
        
        guard article?.thumbnailWidth != nil,
            article?.thumbnailHeight != nil,
            let previewUrl = article?.thumbnail,
            let url = URL(string: previewUrl) else {
                articleImageView.isHidden = true
                return
        }
        
        articleImageView.sd_setImage(with: url) { (image, error, cache, url) in
            guard image != nil else {
                return
            }
            self.articleImageView.isHidden = false
        }
    }
}
