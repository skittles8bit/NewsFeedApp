//
//  ImageLoader.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

/// Протокол сервиса загрузок картинки
protocol ImageLoaderProtocol {
	/// Загрузить картинку
	///  - Parameters:
	///   - url: Ссылка на картинку
	///   - competion: Картинка
	///  - returns: UUID картинки
	func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
	/// Отменить загрузку картинка
	///  - Parameters:
	///   - uuid: UUID картинки
	func cancelLoad(_ uuid: UUID)
}

/// Сервис загрузки картинок
final class ImageLoader {

	private var cache = ImageCache.shared
	private var runningRequests = [UUID: URLSessionDataTask]()
}

// MARK: - ImageLoaderProtocol

extension ImageLoader: ImageLoaderProtocol {

	func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
		if let image = cache.cacheImage(with: url.absoluteString) {
			completion(.success(image))
			return nil
		}

		let uuid = UUID()

		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self else { return }

			defer {
				runningRequests.removeValue(forKey: uuid)
			}

			if let data = data, let image = UIImage(data: data) {
				cache.saveImage(image, with: url.absoluteString)
				completion(.success(image))
				return
			}

			guard let error = error else { return }

			guard (error as NSError).code == NSURLErrorCancelled else {
				completion(.failure(error))
				return
			}
		}
		task.resume()

		runningRequests[uuid] = task
		return uuid
	}

	func cancelLoad(_ uuid: UUID) {
		runningRequests[uuid]?.cancel()
		runningRequests.removeValue(forKey: uuid)
	}
}
