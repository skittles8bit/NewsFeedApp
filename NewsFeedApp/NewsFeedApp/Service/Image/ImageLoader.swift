//
//  ImageLoader.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 22.12.24.
//

import UIKit

final class ImageLoader {

	private var latestTaskId: String = .empty
	private var latestTask: URLSessionDataTask?

	private let imageCache: ImageCache = ImageCache.shared

	private let session: URLSession = {
		let session =  URLSession(configuration: .default)
		return session
	}()

	func configure(from imgPath: String, completionHandler: @escaping ((UIImage?) -> ()) ) {
		if let image = imageCache.cacheImage(with: imgPath) {
			completionHandler(image)
			return
		}

		guard let url = URL(string: imgPath) else { return }

		latestTaskId = UUID().uuidString
		let checkTaskId = latestTaskId

		(latestTask != nil) ? latestTask?.cancel() : ()

		latestTask = session.dataTask(with: url) { (data, response, error) in
			if let err = error {
				DispatchQueue.main.async {
					if self.latestTaskId == checkTaskId {
						completionHandler(nil)
					}
				}
				print(err)
				return
			}

			DispatchQueue.main.async {
				guard
					let data,
					let image = UIImage(data: data)
				else {
					if self.latestTaskId == checkTaskId {
						completionHandler(nil)
					}
					return
				}
				if self.latestTaskId == checkTaskId {
					self.imageCache.saveImage(image, with: imgPath)
					completionHandler(image)
				}
			}
		}
		latestTask?.resume()
	}
}
