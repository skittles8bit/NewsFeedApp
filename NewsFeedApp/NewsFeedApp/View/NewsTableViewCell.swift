//
//  NewsTableViewCell.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerNewsLabel: UILabel!
    @IBOutlet weak var mainTextNewsLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var timePublishedLabel: UILabel!
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        
        headerNewsLabel.text = viewModel.title
        mainTextNewsLabel.text = viewModel.subtitle
        timePublishedLabel.text = viewModel.time?.convertData()
        
        if let imageData = viewModel.imageData {
            newsImageView.image = UIImage(data: imageData)
        } else if let url = viewModel.imageUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
