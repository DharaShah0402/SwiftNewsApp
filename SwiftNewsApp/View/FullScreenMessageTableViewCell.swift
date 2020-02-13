//
//  FullScreenMessageTableViewCell.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation
import UIKit

class FullScreenMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var showLoading: Bool = false {
        didSet {
            if showLoading {
                loadingIndicator.startAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
    }
}
