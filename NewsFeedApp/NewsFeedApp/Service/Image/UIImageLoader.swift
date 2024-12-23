//
//  UIImageLoader.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

/// Сервис загрузки картинки для ячейки
final class UIImageLoader {

	static let loader = UIImageLoader()

	private let imageLoader: ImageLoaderProtocol = ImageLoader()
	private var uuidMap = [UIImageView: UUID]()

	private init() {}

	func load(id: String, _ url: URL, for imageView: UIImageView) {
		let token = imageLoader.loadImage(id: id, url) { [weak self] result in
			guard let self else { return }

			defer {
				uuidMap.removeValue(forKey: imageView)
			}
			do {
				let image = try result.get()
				DispatchQueue.main.async {
					imageView.image = image
				}
			} catch {
				print(error)
			}
		}

		if let token = token {
			uuidMap[imageView] = token
		}
	}

	func cancel(for imageView: UIImageView) {
		if let uuid = uuidMap[imageView] {
			imageLoader.cancelLoad(uuid)
			uuidMap.removeValue(forKey: imageView)
		}
	}
}
