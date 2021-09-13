//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    private var viewModels: TableViewViewModelType?
    private var timer = Timer()
    private var isLoadingNews = false
    private var loadingIndicatorView:  NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupLoadingView()
        //loadingIndicatorView?.startAnimating()
        
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
    
    fileprivate func setupLoadingView() {
        
        loadingIndicatorView = NVActivityIndicatorView(frame: .zero,
                                              type: .ballPulse,
                                              color: .blue,
                                              padding: 0)
        
        loadingIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingIndicatorView!)
        NSLayoutConstraint.activate([
            loadingIndicatorView!.widthAnchor.constraint(equalToConstant: 70),
            loadingIndicatorView!.heightAnchor.constraint(equalToConstant: 70),
            loadingIndicatorView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicatorView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: NSLocalizedString(StringConstants.retry, comment: ""), style: .cancel) { [weak self] _ in
            //self?.loadingIndicatorView?.stopAnimating()
            self?.getPost()
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkingDataLoading),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func checkingDataLoading() {
        if isLoadingNews {
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
                    //self.loadingIndicatorView?.stopAnimating()
                }
                
                self.isLoadingNews = true
            case .failure:
                DispatchQueue.main.async {
                    //self.loadingIndicatorView?.stopAnimating()
                    self.showAlertController(title: NSLocalizedString(StringConstants.error, comment: ""),
                                             message: NSLocalizedString(StringConstants.dataLoadingError, comment: ""))
                }
            }
        }
    }
}
