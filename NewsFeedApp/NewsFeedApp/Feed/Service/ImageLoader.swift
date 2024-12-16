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
		// Проверка на наличие URL
		guard let url = URL(string: urlString) else {
			completion(nil)
			return
		}

		// Проверка кэша
		if let cachedImage = imageCache.object(forKey: urlString as NSString) {
			completion(cachedImage)
			return
		}

		// Загрузка изображения из сети
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			// Обработка ошибок и проверки данных
			guard let data = data, error == nil, let image = UIImage(data: data) else {
				completion(nil)
				return
			}

			// Сохранение изображения в кэш
			self.imageCache.setObject(image, forKey: urlString as NSString)

			// Возвращаем изображение через завершение
			DispatchQueue.main.async {
				completion(image)
			}
		}

		task.resume()
	}
}
