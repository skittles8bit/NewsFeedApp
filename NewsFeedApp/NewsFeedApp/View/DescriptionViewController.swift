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
    
    public var url = URL(string: "https://applejam.by/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
