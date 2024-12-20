//
//  ImageDownloadOperation.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

/// Класс обвертка над operation
final class ImageDownloadOperation: Operation, @unchecked Sendable {

	/// Ссылка на картинку
	let url: URL
	/// Картинка
	var image: UIImage?

	private let imageCache: ImageCache = ImageCache.shared

	/// Инициализатор
	///  - Parameters:
	///   - url: Ссылка на картинку
	init(url: URL) {
		self.url = url
	}

	override func main() {
		// Проверяем, была ли отменена операция
		if isCancelled {
			return
		}

		// Проверяем, есть ли изображение в кеше
		if let cachedImage = imageCache.cacheImage(with: url.absoluteString) {
			self.image = cachedImage
			return
		}

		// Загружаем данные
		guard let data = try? Data(contentsOf: url) else { return }

		// Проверяем, была ли отменена операция после загрузки данных
		if isCancelled {
			return
		}

		// Создаем изображение из данных
		if let downloadedImage = UIImage(data: data) {
			self.image = downloadedImage

			imageCache.saveImage(downloadedImage, with: url.absoluteString)
		}
	}
}
