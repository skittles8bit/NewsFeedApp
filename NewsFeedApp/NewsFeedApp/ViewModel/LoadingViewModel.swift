//
//  LoadingViewModel.swift
//  NewsFeedApp
//
//  Created by Alex on 9/14/21.
//

import Foundation
import NVActivityIndicatorView

class LoadingViewModel: LoadingViewModelType, NewsViewModelType {
    
    var timer = Timer()
    private var articles: [ArticleModel]?
    private(set) var loadingIndicatorView:  NVActivityIndicatorView?
    
    var isLoadingNews: Bool?
    var numberOfRows: Int {
        return articles?.count ?? 0
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
    
    func createAlertController(title: String, message: String, handler: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: StringConstants.retry.localized, style: .destructive, handler: handler)
    
        ac.addAction(action)
        return ac
    }
    
    func presentNewsViewController(view: UIView, viewModel: LoadingViewModel) {
        
        let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StringConstants.mainStoryboard, bundle: nil)
        let newsViewController = mainStoryboard.instantiateViewController(withIdentifier: StringConstants.newsViewController) as! NewsViewController
        let navigationController = UINavigationController(rootViewController: newsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.topItem?.title = StringConstants.news.localized
        
        newsViewController.viewModels = viewModel
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
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
