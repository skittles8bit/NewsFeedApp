//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var customIndicatorImageView: UIImageView! {
        didSet {
            customIndicatorImageView.image = viewModels.setImage(imageByName: "loadingIndicator")
        }
    }
    
    private var timer: Timer?
    private var viewModels = LoadingViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.customIndicatorImageView.isHidden = true
        getPost()
    }
}

private extension LoadingViewController {

    func startAnimate() {
        
        self.customIndicatorImageView.isHidden = false
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
        }
    }
    
    func stopAnimate() {
        
        self.customIndicatorImageView.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc func animateView() {
    
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear, animations: {
                   self.customIndicatorImageView.transform = self.customIndicatorImageView.transform.rotated(by: CGFloat(Double.pi))
               }, completion: { [weak self] finished in
                
                   if self?.timer != nil {
                        self?.timer = Timer.scheduledTimer(timeInterval:0.0,
                                                           target: self as Any,
                                                           selector: #selector(self?.animateView),
                                                           userInfo: nil,
                                                           repeats: false)
                   } else {
                        self?.presentNewsViewController()
                   }
                   
               })
    }
    
    func getPost() {
        
        startAnimate()
        
        self.viewModels.getPost { [weak self] news, status, error in
            
            switch status {
            case .satisfied:
                if let news = news { 
                    
                    self?.viewModels.updateAticles(articles: news)
                    
                    DispatchQueue.main.async {
                        self?.stopAnimate()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.stopAnimate()
                        self?.showAlertController(title: StringConstants.error.localized,
                                                  message: StringConstants.dataLoadingError.localized)
                    }
                }
            default:
                DispatchQueue.main.async {
                    self?.stopAnimate()
                    self?.showAlertController(title: StringConstants.error.localized,
                                              message: StringConstants.dataLoadingError.localized)
                }
            }
        }
    }
    
    func showAlertController(title: String, message: String) {
    
        let ac = viewModels.createAlertController(title: title, message: message, handler: { [weak self] _ in
            
            self?.startAnimate()
            
            self?.getPost()
        })
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func presentNewsViewController() {
        
        viewModels.presentNewsViewController(view: self.view, viewModel: viewModels)
    }
}
