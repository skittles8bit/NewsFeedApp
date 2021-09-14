//
//  File.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation
import UIKit

protocol LoadingViewModelType {
    func updateIsLoadingNews(value: Bool)
    func updateAticles(articles: [ArticleModel])
    func setupLoadingView() -> UIView
    func addConstraintsForLoadingView(view: UIView) -> [NSLayoutConstraint]
    func getPost(completionHandler: @escaping ([ArticleModel]?, ConnectionStatus, Error?) -> Void)
}
