//
//  File.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation
import UIKit

protocol LoadingViewModelType {
    func updateAticles(articles: [ArticleModel])
    func getPost(completionHandler: @escaping ([ArticleModel]?, ConnectionStatus, Error?) -> Void)
}
