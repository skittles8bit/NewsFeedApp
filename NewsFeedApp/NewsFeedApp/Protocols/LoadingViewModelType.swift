//
//  File.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation
import UIKit

protocol LoadingViewModelType: NewsViewModelType {
    func updateIsLoadingNews(value: Bool)
    func updateAticles(articles: [ArticleModel])
    func setupLoadingView() -> UIView
    func addConstraintsForLoadingView(view: UIView) -> [NSLayoutConstraint]
    func getPost(completionHandler: @escaping ([ArticleModel]?, ConnectionStatus, Error?) -> Void)
}

extension LoadingViewModelType {
    var numberOfRows: Int {
        return 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsCellViewModelType? {
        
        return NewsTableViewCellViewModel(article: ArticleModel(title: "",
                                                                subtitle: "",
                                                                imageUrl: URL(string: ""),
                                                                url: URL(string: ""),
                                                                time: ""))
    }
}
