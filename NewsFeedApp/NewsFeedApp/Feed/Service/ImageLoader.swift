//
//  ImageLoader.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 16.12.24.
//

import UIKit

protocol ImageLoaderProtocol {
	func loadImage(from url: URL) async -> UIImage?
}

class ImageLoader {

	private let memoryCache = NSCache<NSURL, UIImage>()
	private let diskCacheDirectory: URL

	init() {
		self.diskCacheDirectory = FileManager.default.urls(
			for: .cachesDirectory,
			in: .userDomainMask
		)[0].appendingPathComponent("Images")
	}
}

// MARK: - ImageLoaderProtocol

extension ImageLoader: ImageLoaderProtocol {

	func loadImage(from url: URL) async -> UIImage? {
		await loadImageInternal(from: url)
	}
}

// MARK: - Private

private extension ImageLoader {

	func loadImageInternal(from url: URL) async -> UIImage? {
		// Проверяем память
		if let cachedImage = memoryCache.object(forKey: url as NSURL) {
			return cachedImage
		}

		// Проверяем дисковый кэш
		let diskCachePath = diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
		if let imageFromDisk = UIImage(contentsOfFile: diskCachePath.path) {
			memoryCache.setObject(imageFromDisk, forKey: url as NSURL)
			return imageFromDisk
		}

		// Загружаем изображение из сети
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			guard
				let image = UIImage(data: data),
				let response = response as? HTTPURLResponse,
				response.statusCode == 200
			else {
				return nil
			}

			// Сохраняем изображение в память
			memoryCache.setObject(image, forKey: url as NSURL)

			// Сохраняем изображение на диск
			do {
				try data.write(to: diskCachePath)
			} catch {
				print("Error saving image to disk: \(error)")
			}

			return image
		} catch {
			print("Error loading image: \(error)")
			return nil
		}
	}
}
