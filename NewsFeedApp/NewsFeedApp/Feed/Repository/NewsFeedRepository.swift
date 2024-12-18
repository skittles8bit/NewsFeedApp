//
//  Repository.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

protocol NewsFeedRepositoryProtocol {
	func fetchNewsFeed() async -> [NewsFeedModelDTO]?
}

final class NewsFeedRepository {

	private let storage: StorageServiceProtocol
	private let apiService: APIServiceProtocol

	init(
		storage: StorageServiceProtocol,
		apiService: APIServiceProtocol
	) {
		self.storage = storage
		self.apiService = apiService
	}
}

extension NewsFeedRepository: NewsFeedRepositoryProtocol {

	func fetchNewsFeed() async -> [NewsFeedModelDTO]? {
		let dataModel = storage.fetch(by: NewsFeedObject.self)
		guard dataModel.count > .zero else {
			do {
				let news = try await apiService.fetchAndParseRSSFeeds()
				let objects = news.compactMap { NewsFeedObject(from: $0) }
				storage.save(objects: objects)
				return news
			} catch {
				print("Ошибка при загрузке или разборе RSS: \(error)")
				return nil
			}
		}
		return dataModel.compactMap {
			NewsFeedModelDTO(from: $0)
		}
	}
}
