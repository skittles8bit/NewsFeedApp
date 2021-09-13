//
//  NewsTableViewCell.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var headerNewsLabel: UILabel!
    @IBOutlet private weak var mainTextNewsLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var timePublishedLabel: UILabel!
    
    weak var viewModel: NewsCellViewModelType? {
        willSet(viewModel) {
            headerNewsLabel.text = viewModel?.title
            mainTextNewsLabel.text = viewModel?.subtitle?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            timePublishedLabel.text = viewModel?.time?.getFormattedDate()
            
            if let imageData = viewModel?.imageData {
                newsImageView.image = UIImage(data: imageData)
            } else if let viewModel = viewModel {
                NetworkService.shared.loadImage(viewModel: viewModel) { [weak self] data in
                    self?.viewModel?.imageData = data
                    
                    DispatchQueue.main.async {
                        self?.newsImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
