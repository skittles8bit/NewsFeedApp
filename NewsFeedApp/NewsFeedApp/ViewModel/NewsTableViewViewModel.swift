//
//  NewsTableViewCellViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

class NewsTableViewViewModel: NewsViewModelType {
    
    private var articles: [ArticleModel]?
    
    var numberOfRows: Int {
        return articles?.count ?? 0
    }
    
    func updateAticles(articles: [ArticleModel]) {
        self.articles = articles
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsCellViewModelType? {
        guard let arcticles = articles?[indexPath.row] else {
            return NewsTableViewCellViewModel(article: ArticleModel(title: "",
                                                                    subtitle: "",
                                                                    imageUrl: URL(string: ""),
                                                                    url: URL(string: ""),
                                                                    time: ""))
        }
        
        return NewsTableViewCellViewModel(article: arcticles)
    }
}
