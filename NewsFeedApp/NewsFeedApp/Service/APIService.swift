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
	func fetchAndParseRSSFeeds() async throws -> [NewsFeedModelDTO]
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

	func fetchAndParseRSSFeeds() async throws -> [NewsFeedModelDTO] {
		var allItems = [NewsFeedModelDTO]()

		let news = [
			Constants.vedomosti,
			Constants.cbsnews,
			Constants.nytimes,
			Constants.lenta
		]

		for url in news {
			do {
				try await rssParser.parseRSS(at: url)
			} catch {
				throw error
			}
			allItems.append(contentsOf: rssParser.items)
		}

		return allItems.uniqued().sorted { prev, curr in
			guard
				let prevPublicationDate = prev.publicationDate,
				let currPublicationDate = curr.publicationDate
			else {
				return false
			}
			return prevPublicationDate > currPublicationDate
		}
	}
}

// MARK: - Private

private extension APIService {

	enum Constants {
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml"
		static let vedomosti = "https://www.vedomosti.ru/rss/news.xml"
		static let cbsnews = "https://www.cbsnews.com/latest/rss/main"
		static let lenta = "https://www.lenta.ru/rss/articles/russia"
	}
}
