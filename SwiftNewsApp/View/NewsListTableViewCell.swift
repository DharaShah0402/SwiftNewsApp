//
//  File.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class NewsListTableViewCell: UITableViewCell {
    @IBOutlet weak var articleTitle : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    private var urlString: String?
    @IBOutlet weak var theImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var theImageViewWidthConstraint: NSLayoutConstraint!

    
    var imageRatio: CGFloat = 0.0
    
    override func prepareForReuse() {
        thumbnailImage.image = nil
        thumbnailImage.isHidden = true
    }
    
    func loadImage(from url: URL, width: Float,height: Float,completion: @escaping () -> Void) {
        self.urlString = url.absoluteString
        
        thumbnailImage.sd_setImage(with: url) { [weak self] (image,error, cacheType, url) in
            guard image != nil else {
                return
            }
            
            self?.thumbnailImage.isHidden = false
            
            guard (self?.theImageViewWidthConstraint.constant != CGFloat(width) &&
                self?.theImageViewHeightConstraint.constant != CGFloat(height)) else {
                    return
            }
                
            self?.theImageViewHeightConstraint.constant = CGFloat(height)
            self?.theImageViewWidthConstraint.constant = CGFloat(width)
            completion()
        }
    }
    
}

