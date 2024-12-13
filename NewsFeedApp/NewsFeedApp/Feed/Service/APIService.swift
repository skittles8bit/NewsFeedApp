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

	private let rssParser: RSSParserProtocol

	init(rssParser: RSSParserProtocol) {
		self.rssParser = rssParser
	}
}

extension APIService: APIServiceProtocol {

	func fetchAndParseRSSFeeds() async throws -> [NewsModel] {
		var allItems = [NewsModel]()

		for url in [Constants.nytimes, Constants.vedomosti] {
			try await rssParser.parseRSS(at: url)
			allItems.append(contentsOf: rssParser.items)
		}

		return allItems
	}
}

private extension APIService {

	enum Constants {
		static let nytimes = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml"
		static let vedomosti = "https://www.vedomosti.ru/rss/news.xml"
	}
}
