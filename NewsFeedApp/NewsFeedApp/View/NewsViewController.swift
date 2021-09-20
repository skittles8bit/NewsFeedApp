//
//  NewsViewController.swift
//  NewsFeedApp
//
//  Created by Alexander Karenski on 6.09.21.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    public var viewModels: NewsViewModelType?
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.cellIdentifier,
                                                     for: indexPath) as? NewsTableViewCell
        else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModels?.cellViewModel(forIndexPath: indexPath)
        
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellViewModel = viewModels?.cellViewModel(forIndexPath: indexPath)
        guard let url = cellViewModel?.url else {
            return
        }
        
        self.present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
    
}
