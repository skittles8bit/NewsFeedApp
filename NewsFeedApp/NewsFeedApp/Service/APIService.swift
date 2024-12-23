//
//  APIService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

/// Протокол сервиса работы с нетворкингом
protocol APIServiceProtocol {
	/// Получить rss новостную ленту
	///  - returns: Массив новостей
	func fetchAndParseRSSFeeds(with source: [String]) async throws -> [NewsFeedModelDTO]
}

/// Сервиса работы с нетворкингом
final class APIService {

	private let rssParser: RSSParserServiceProtocol

	/// Инициализатор
	///  - Parameters:
	///   - rssParser: Сервис работы с RSS данными
	init(rssParser: RSSParserServiceProtocol) {
		self.rssParser = rssParser
	}
}

// MARK: - APIServiceProtocol

extension APIService: APIServiceProtocol {

	func fetchAndParseRSSFeeds(with source: [String]) async throws -> [NewsFeedModelDTO] {
		var allItems = [NewsFeedModelDTO]()

		for url in source {
			do {
				try await rssParser.parseRSS(at: url)
			} catch {
				throw error
			}
			allItems.append(contentsOf: rssParser.items)
		}

		return allItems
	}
}
