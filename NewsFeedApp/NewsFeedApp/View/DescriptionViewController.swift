//
//  DescriptionViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit
import WebKit

class DescriptionViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    public var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendRequest(with: url)
    }
    
    private func sendRequest(with url: URL?) {
        
        guard let url = url else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
}

extension DescriptionViewController: UIWebViewDelegate {
    
    private func webViewDidFinishLoad(_ webView: WKWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    private func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        let ac = UIAlertController(title: "Error", message: "Error loading page. Do you refresh page?", preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default) { [weak self] _ in
            self?.sendRequest(with: self?.url)
        }
        ac.addAction(action)
        
        ac.present(self, animated: true)
    }
}
