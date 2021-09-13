//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var viewModels: TableViewViewModelType?
    private var timer = Timer()
    private var complitedLoadingNews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        setupTimer()
        
        ConnectionMonitorService.shared.monitorConnection { [weak self] status in
            
            switch status {
            case .satisfied:
                self?.getPost()
            default:
                self?.showAlertController(title: NSLocalizedString(StringConstants.warning, comment: ""),
                                          message: NSLocalizedString(StringConstants.noInternetConnection, comment: ""))
            }
        }
        
    }
    
    private func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: NSLocalizedString(StringConstants.retry, comment: ""), style: .cancel) { [weak self] _ in
            self?.loadingIndicator.stopAnimating()
            self?.getPost()
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkedLoadingPosts),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func checkedLoadingPosts() {
        if complitedLoadingNews {
            timer.invalidate()
            
            presentNewsViewController()
        }
    }
    
    fileprivate func presentNewsViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: StringConstants.mainStoryboard, bundle: nil)
        let newsViewController = storyBoard.instantiateViewController(withIdentifier: StringConstants.newsViewController) as! NewsViewController
        newsViewController.viewModels = viewModels
        newsViewController.modalPresentationStyle = .fullScreen
        self.present(newsViewController, animated: true, completion: nil)
    }
    
    private func getPost() {
        NetworkService.shared.getPosts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let news):
                
                self.viewModels = NewsTableViewViewModel(news: news.compactMap({
                    ArticleModel(title: $0.author ?? NSLocalizedString(StringConstants.emptyAuthor, comment: ""),
                                 subtitle: $0.description ?? NSLocalizedString(StringConstants.emptyDescription, comment: ""),
                                 imageUrl: URL(string: $0.urlToImage ?? ""),
                                 url: URL(string: $0.url ?? ""),
                                 time: $0.publishedAt)
                    
                }))
                
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                }
                
                self.complitedLoadingNews = true
            case .failure:
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.showAlertController(title: NSLocalizedString(StringConstants.error, comment: ""),
                                             message: NSLocalizedString(StringConstants.dataLoadingError, comment: ""))
                }
            }
        }
    }
}
