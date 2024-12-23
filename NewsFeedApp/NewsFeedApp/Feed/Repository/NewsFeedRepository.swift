//
//  Repository.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

/// Протокол репозитория ленты новостей
protocol NewsFeedRepositoryProtocol {
	/// Получение новостей из
	///  - returns: Массив новостей
	func fetchNewsFeed() -> [NewsFeedModelDTO]?
	/// Загрузка новостей
	///  - returns: Массив новостей
	func loadNews() async -> [NewsFeedModelDTO]?
	/// Сохранение объекта в БД
	///  - Parameters:
	///   - model: Модель данных ленты новостей
	func saveObject(with model: NewsFeedModelDTO)
	/// Удаление всех объектов из БД
	func removeAll()
}

/// Класс репозитория ленты новостей
final class NewsFeedRepository {

	private let storage: StorageServiceProtocol
	private let apiService: APIServiceProtocol

	/// Инициализатор
	///  - Parameters:
	///   - storage: Сервис хранения данных
	///   - apiService: Серсис загрузки API
	init(
		storage: StorageServiceProtocol,
		apiService: APIServiceProtocol
	) {
		self.storage = storage
		self.apiService = apiService
	}
}

// MARK: - NewsFeedRepositoryProtocol

extension NewsFeedRepository: NewsFeedRepositoryProtocol {

	func fetchNewsFeed() -> [NewsFeedModelDTO]? {
		storage.fetch(by: NewsFeedObject.self).compactMap {
			NewsFeedModelDTO(from: $0)
		}
	}

	func loadNews() async -> [NewsFeedModelDTO]? {
		do {
			var sources: [String] = [
				Constants.nytimes,
				Constants.vedomosti,
				Constants.cbsnews,
				Constants.lenta
			]
			let objects = storage.fetch(by: NewsSourceObject.self)
			if !objects.isEmpty {
				sources = objects.compactMap { $0.name }
			}
			return try await apiService.fetchAndParseRSSFeeds(with: sources)
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

// MARK: - Private

private extension NewsFeedRepository {

	enum Constants {
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml"
		static let vedomosti = "https://www.vedomosti.ru/rss/news.xml"
		static let cbsnews = "https://www.cbsnews.com/latest/rss/main"
		static let lenta = "https://www.lenta.ru/rss/articles/russia"
	}
}
