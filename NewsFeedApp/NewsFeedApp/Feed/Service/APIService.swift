//
//  APIService.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

protocol APIServiceProtocol {
	func fetchAndParseRSSFeeds() async throws -> [NewsModel]
}

final class APIService {

	private let rssParser: RSSParserServiceProtocol

	init(rssParser: RSSParserServiceProtocol) {
		self.rssParser = rssParser
	}
}

extension APIService: APIServiceProtocol {

	func fetchAndParseRSSFeeds() async throws -> [NewsModel] {
		var allItems = [NewsModel]()

		let news = [
			Constants.vedomosti,
			Constants.nytimes
		]

		for url in news {
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

private extension APIService {

	enum Constants {
		static let vedomosti = "https://www.lenta.ru/rss/articles/russia"
		static let vedomosti1 = "https://www.lenta.ru/rss/news"
		static let vedomosti2 = "https://www.lenta.ru/rss/top7"
		static let vedomosti3 = "https://www.lenta.ru/rss/last24"
		static let vedomosti4 = "https://www.lenta.ru/rss/photo/russia"
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml"
	}
}
