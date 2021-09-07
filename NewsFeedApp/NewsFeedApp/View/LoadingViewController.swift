//
//  LoadingViewController.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var timer = Timer()
    private var complitedLoadingNews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.startAnimating()
        setupTimer()
        getPost()
    }
    
    private func setupTimer() {
        print("Start timer")
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkedLoadingPosts), userInfo: nil, repeats: true)
    }
    
    @objc private func checkedLoadingPosts() {
        if complitedLoadingNews {
            timer.invalidate()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newsViewController = storyBoard.instantiateViewController(withIdentifier: "newsViewController") as! NewsViewController
            newsViewController.viewModels = viewModels
            self.navigationController?.pushViewController(newsViewController, animated: true)
        }
    }
    
    private func getPost() {
        NetworkService.shared.getPosts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let news):
                self.viewModels = news.compactMap({
                    NewsTableViewCellViewModel(title: $0.author ?? "Empty author",
                                               subtitle: $0.description ?? "Empty description",
                                               imageUrl: URL(string: $0.urlToImage ?? ""),
                                               url: URL(string: $0.url ?? ""))
                    
                })
                
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                }
                
                self.complitedLoadingNews = true
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
