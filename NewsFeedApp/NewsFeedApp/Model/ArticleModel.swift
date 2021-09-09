//
//  ArticleModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation

class ArticleModel {
    
    let title: String
    let subtitle: String
    let imageUrl: URL?
    var imageData: Data? = nil
    var url: URL?
    var time: String?
    
    init(title: String, subtitle: String, imageUrl: URL?, url: URL?, time: String?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.url = url
        self.time = time
    }
}
