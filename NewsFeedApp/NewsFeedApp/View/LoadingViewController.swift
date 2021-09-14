//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    private var viewModels = LoadingViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTimer()
        addLoadingIndicatorOnView()
        getPost()
    }
}

private extension LoadingViewController {
    
    func addLoadingIndicatorOnView() {
        self.view.addSubview(viewModels.setupLoadingView())
        NSLayoutConstraint.activate(viewModels.addConstraintsForLoadingView(view: self.view))
    }
    
    func setupTimer() {
        
        viewModels.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkingDataLoading),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func checkingDataLoading() {
        
        if viewModels.isLoadingNews != nil{
            viewModels.timer.invalidate()
            
            viewModels.loadingIndicatorView?.stopAnimating()
            
            presentNewsViewController()
        }
    }
    
    func getPost() {
        
        self.viewModels.getPost { [weak self] news, status, error in
            
            switch status {
            case .satisfied:
                if let news = news{
                    
                    self?.viewModels.updateAticles(articles: news)
                    self?.viewModels.isLoadingNews = true
                    
                    DispatchQueue.main.async {
                        self?.viewModels.loadingIndicatorView?.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.viewModels.loadingIndicatorView?.stopAnimating()
                        self?.showAlertController(title: StringConstants.error.localized,
                                                  message: StringConstants.dataLoadingError.localized)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self?.viewModels.loadingIndicatorView?.stopAnimating()
                    self?.showAlertController(title: StringConstants.error.localized,
                                              message: StringConstants.dataLoadingError.localized)
                }
            }
        }
    }
    
   func showAlertController(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: StringConstants.retry.localized, style: .destructive) { [weak self] _ in
            self?.viewModels.loadingIndicatorView?.startAnimating()
            
            self?.getPost()
        }
    
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
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
