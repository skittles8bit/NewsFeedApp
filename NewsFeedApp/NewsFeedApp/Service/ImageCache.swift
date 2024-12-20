//
//  ImageCache.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

final class ImageCache {

	static let shared = ImageCache()

	private var imageCache = NSCache<NSString, UIImage>()

	private init() {}

	func saveImage(_ image: UIImage, with urlString: String) {
		imageCache.setObject(image, forKey: urlString as NSString)
	}

	func cacheImage(with urlString: String) -> UIImage? {
		imageCache.object(forKey: urlString as NSString)
	}

	func clearMemoryCache() {
		imageCache.removeAllObjects()
	}
}
