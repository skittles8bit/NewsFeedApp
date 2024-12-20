//
//  Repository.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

protocol NewsFeedRepositoryProtocol {
	func fetchNewsFeed() -> [NewsFeedModelDTO]?
	func loadNews() async -> [NewsFeedModelDTO]?
	func saveObject(with model: NewsFeedModelDTO)
	func removeAll()
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

	func fetchNewsFeed() -> [NewsFeedModelDTO]? {
		storage.fetch(by: NewsFeedObject.self).compactMap {
			NewsFeedModelDTO(from: $0)
		}
	}

	func loadNews() async -> [NewsFeedModelDTO]? {
		do {
			return try await apiService.fetchAndParseRSSFeeds()
		} catch {
			print("Ошибка при загрузке или разборе RSS: \(error)")
			return nil
		}
	}

	func removeAll() {
		storage.deleteAll()
	}

	func saveObject(with model: NewsFeedModelDTO) {
		storage.saveOrUpdate(object: NewsFeedObject(from: model))
	}
}
