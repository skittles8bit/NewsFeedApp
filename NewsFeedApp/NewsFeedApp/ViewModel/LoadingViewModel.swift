//
//  LoadingViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation
import NVActivityIndicatorView

class LoadingViewModel: LoadingViewModelType {
    
    var timer = Timer()
    private var articles: [ArticleModel]?
    private(set) var loadingIndicatorView:  NVActivityIndicatorView?
    
    var isLoadingNews: Bool?
    
    func updateIsLoadingNews(value: Bool) {
        
        self.isLoadingNews = value
    }
    
    func updateAticles(articles: [ArticleModel]) {
        
        self.articles = articles
    }
    
    func setupLoadingView() -> UIView {
        
        loadingIndicatorView = NVActivityIndicatorView(frame: .zero,
                                              type: .ballPulse,
                                              color: .blue,
                                              padding: 0)
        
        loadingIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingIndicatorView!
    }
    
    func addConstraintsForLoadingView(view: UIView) -> [NSLayoutConstraint] {
        return [
            loadingIndicatorView!.widthAnchor.constraint(equalToConstant: 70),
            loadingIndicatorView!.heightAnchor.constraint(equalToConstant: 70),
            loadingIndicatorView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorView!.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
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
