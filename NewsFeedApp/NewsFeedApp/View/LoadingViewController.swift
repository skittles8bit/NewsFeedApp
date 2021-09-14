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
        
        setupLoadingView()
        loadingIndicatorView?.startAnimating()
        
        getPost()
    }
}

private extension LoadingViewController {
    
    func getPost() {
        self.viewModels.getPost { [weak self] news, status, error in
            
            switch status {
            case .satisfied:
                if let news = news{
                    
                    self?.viewModels.updateAticles(articles: news)
                    self?.isLoadingNews = true
                    
                    DispatchQueue.main.async {
                        self?.loadingIndicatorView?.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.loadingIndicatorView?.stopAnimating()
                        self?.showAlertController(title: StringConstants.error, message: StringConstants.dataLoadingError)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self?.loadingIndicatorView?.stopAnimating()
                    self?.showAlertController(title: StringConstants.error, message: StringConstants.dataLoadingError)
                }
            }
        }
    }
    
    
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
        let action = UIAlertAction(title: NSLocalizedString(StringConstants.retry, comment: ""), style: .destructive) { [weak self] _ in
            self?.loadingIndicatorView?.startAnimating()
            
            self?.getPost()
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
            
            loadingIndicatorView?.stopAnimating()
            
            presentNewsViewController()
        }
    }
    
    func presentNewsViewController() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StringConstants.mainStoryboard, bundle: nil)
        let newsViewController = mainStoryboard.instantiateViewController(withIdentifier: StringConstants.newsViewController) as! NewsViewController
        let navigationController = UINavigationController(rootViewController: newsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        newsViewController.viewModels = viewModels
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
