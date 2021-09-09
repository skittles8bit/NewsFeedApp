//
//  NewsTableViewCellViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

class NewsTableViewViewModel: TableViewViewModelType {
    
    var articles: [ArticleModel]
    
    init(news: [ArticleModel]) {
        self.articles = news
    }
    
    var numberOfRows: Int {
        return articles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let arcticles = articles[indexPath.row]
        
        return NewsTableViewCellViewModel(article: arcticles)
    }
}
