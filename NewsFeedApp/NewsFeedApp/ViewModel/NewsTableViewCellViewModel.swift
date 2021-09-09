//
//  TableViewCellViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation

class NewsTableViewCellViewModel: TableViewCellViewModelType {

    private var article: ArticleModel
    
    var title: String {
        article.title
    }
    
    var subtitle: String {
        article.subtitle
    }
    
    var imageUrl: URL? {
        article.imageUrl
    }
    
    var imageData: Data? {
        get {
            article.imageData
        }
        set {
            article.imageData = newValue
        }
    }
    
    var url: URL? {
        article.url
    }
    
    var time: String? {
        article.time
    }
    
    init(article: ArticleModel) {
        self.article = article
    }
    
}
