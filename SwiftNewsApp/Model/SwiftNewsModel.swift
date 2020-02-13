//
//  SwiftNewsModel.swift
//  SwiftNewsApp
//
//  Copyright © 2020 Dhara Shah. All rights reserved.
//

import Foundation

struct SwiftResponse {
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case data, children
    }
}

extension SwiftResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy:
        CodingKeys.self, forKey: .data)
        self.articles = try data.decode([Article].self, forKey: .children)
    }
}

struct Article {
    let title: String
    let body: String?
    
    let thumbnailWidth: Float?
    let thumbnailHeight: Float?
    let thumbnail: String?
        
    enum CodingKeys: String, CodingKey {
        case data
        case title = "title"
        case body =  "selftext"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case thumbnail = "thumbnail"
    }
}

extension Article: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy:
        CodingKeys.self, forKey: .data)
        
        self.title = try data.decode(String.self, forKey: .title)
        self.body = try data.decode(String?.self, forKey: .body)
        self.thumbnailWidth = try data.decode(Float?.self, forKey: .thumbnailWidth)
        self.thumbnailHeight = try data.decode(Float?.self, forKey: .thumbnailHeight)
        self.thumbnail = try data.decode(String?.self, forKey: .thumbnail)
    }
}
