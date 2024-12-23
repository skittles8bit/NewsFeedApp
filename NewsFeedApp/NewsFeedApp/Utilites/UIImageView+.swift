//
//  UIImageView+.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

extension UIImageView {

	func loadImage(with id: String, and urlString: String) {
		guard let url = URL(string: urlString) else { return }
		UIImageLoader.loader.load(id: id, url, for: self)
	}

	func cancelImageLoad() {
		UIImageLoader.loader.cancel(for: self)
	}
}
