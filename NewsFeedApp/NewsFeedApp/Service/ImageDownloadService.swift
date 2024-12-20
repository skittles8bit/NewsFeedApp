//
//  ImageDownloadService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 20.12.24.
//

import UIKit

class ImageDownloadService {

	private let operationQueue: OperationQueue

	static let shared = ImageDownloadService()

	private init() {
		operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 4
	}

	func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
		guard let url = URL(string: urlString) else { return }
		let operation = ImageDownloadOperation(url: url)

		operation.completionBlock = {
			if let image = operation.image {
				DispatchQueue.main.async {
					completion(image)
				}
			} else {
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		}

		operationQueue.addOperation(operation)
	}
}
