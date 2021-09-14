//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

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
        
        guard let isCompletedLoadingData = viewModels.isLoadingNews else { return }
        
        if isCompletedLoadingData {
            viewModels.timer.invalidate()
            
            viewModels.loadingIndicatorView?.stopAnimating()
            
            presentNewsViewController()
        }
    }
    
    func getPost() {
        
        viewModels.loadingIndicatorView?.startAnimating()
        
        self.viewModels.getPost { [weak self] news, status, error in
            
            switch status {
            case .satisfied:
                if let news = news { 
                    
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
    
        let ac = viewModels.createAlertController(title: title, message: message, handler: { [weak self] _ in
            self?.viewModels.loadingIndicatorView?.startAnimating()
            
            self?.getPost()
        })
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func presentNewsViewController() {
        
        viewModels.presentNewsViewController(view: self.view, viewModel: viewModels)
    }
}
