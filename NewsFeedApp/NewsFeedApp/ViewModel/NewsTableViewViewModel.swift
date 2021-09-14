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
    
    func getPost(completionHandler: @escaping ([ArticleModel]?, ConnectionStatus, Error?) -> Void) {
        
        ConnectionMonitorService.shared.monitorConnection {status in
            
            switch status {
                case .satisfied:
                    NetworkService.shared.getPosts {result in

                        switch result {
                        case .success(let news):
                            
                            completionHandler(news.compactMap({
                                ArticleModel(title: $0.author ?? StringConstants.emptyAuthor.localized,
                                             subtitle: $0.description ?? StringConstants.emptyDescription.localized,
                                             imageUrl: URL(string: $0.urlToImage ?? ""),
                                             url: URL(string: $0.url ?? ""),
                                             time: $0.publishedAt)
                                
                            }), status, nil)
                        case .failure(let error):
                            completionHandler(nil, status, error)
                        }
                    }
                default:
                    completionHandler(nil, status, nil)
            }
        }
    }
}
