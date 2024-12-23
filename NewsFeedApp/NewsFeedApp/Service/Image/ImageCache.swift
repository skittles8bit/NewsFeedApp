//
//  ImageCache.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

/// Сервис кэша изображений
final class ImageCache {

	static let shared = ImageCache()

	private var imageCache = NSCache<NSString, UIImage>()

	private init() {}

	/// Сохранить картинку
	///  - Parameters:
	///   - image: Картинка
	///   - urlString: Ссылка на картинку
	func saveImage(_ image: UIImage, with id: String) {
		imageCache.setObject(image, forKey: id as NSString)
	}

	/// Получить картинку
	///  - Parameters:
	///   - urlString: Ссылка на картинку
	func cacheImage(with id: String) -> UIImage? {
		imageCache.object(forKey: id as NSString)
	}

	/// Очистить кэш
	func clearMemoryCache() {
		imageCache.removeAllObjects()
	}
}
