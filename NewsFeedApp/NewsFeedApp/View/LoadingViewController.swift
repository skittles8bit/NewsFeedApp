//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    private var viewModels =  NewsTableViewViewModel()
    private var timer = Timer()
    private var isLoadingNews = false
    private var loadingIndicatorView:  NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimer()
        
        self.viewModels.getPost { [weak self] news, status in
            switch status {
            
            case .satisfied:
                guard let news = news else {
                    return
                }
                
                self?.viewModels = NewsTableViewViewModel(news: news)
                self?.isLoadingNews = true
            default:
                self?.showAlertController(title: StringConstants.error, message: StringConstants.dataLoadingError)
            }
        }
    }
}

private extension LoadingViewController {
    
    func setupLoadingView() {
        
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
    
   func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: NSLocalizedString(StringConstants.retry, comment: ""), style: .cancel) { [weak self] _ in
            //self?.loadingIndicatorView?.stopAnimating()
            self?.viewModels.getPost { [weak self] news, status in
                switch status {
                
                case .satisfied:
                    guard let news = news else {
                        return
                    }
                    
                    self?.viewModels = NewsTableViewViewModel(news: news)
                    self?.isLoadingNews = true
                default:
                    self?.showAlertController(title: StringConstants.error, message: StringConstants.dataLoadingError)
                }
            }
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkingDataLoading),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func checkingDataLoading() {
        if isLoadingNews {
            timer.invalidate()
            
            presentNewsViewController()
        }
    }
    
    func presentNewsViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: StringConstants.mainStoryboard, bundle: nil)
        let newsViewController = storyBoard.instantiateViewController(withIdentifier: StringConstants.newsViewController) as! NewsViewController
        newsViewController.viewModels = viewModels
        newsViewController.modalPresentationStyle = .fullScreen
        self.present(newsViewController, animated: true, completion: nil)
    }
}
