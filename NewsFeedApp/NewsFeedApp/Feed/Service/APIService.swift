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

private extension APIService {

	enum Constants {
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml"
		static let vedomosti = "https://www.vedomosti.ru/rss/news.xml"
		static let lenta = "https://www.lenta.ru/rss/articles/russia"
	}
}
