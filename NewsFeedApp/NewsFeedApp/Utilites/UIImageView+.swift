//
//  UIImageView+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

extension UIImageView {

	func setImage(from urlString: String) {
		self.image = UIImage(named: "placeholder-image")
		ImageDownloadService.shared.downloadImage(from: urlString) { [weak self] image in
			guard let self else { return }
			self.image = image
		}
	}
}