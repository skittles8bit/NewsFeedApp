//
//  NewsTableViewCellViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageUrl: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageUrl: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}
