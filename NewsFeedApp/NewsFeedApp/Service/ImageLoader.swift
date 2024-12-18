//
//  ImageLoader.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import UIKit

final class ImageLoader {
	static let shared = ImageLoader()

	private var imageCache = NSCache<NSString, UIImage>()

	private init() {}

	func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
		guard let url = URL(string: urlString) else {
			completion(nil)
			return
		}

		if let cachedImage = imageCache.object(forKey: urlString as NSString) {
			completion(cachedImage)
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil, let image = UIImage(data: data) else {
				completion(nil)
				return
			}

			self.imageCache.setObject(image, forKey: urlString as NSString)

			DispatchQueue.main.async {
				completion(image)
			}
		}

		task.resume()
	}

	func clearCache() {
		imageCache.removeAllObjects()
	}
}
