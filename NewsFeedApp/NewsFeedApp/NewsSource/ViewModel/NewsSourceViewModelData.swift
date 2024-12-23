//
//  NewsSourceViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Combine

struct NewsSourceViewModelData {

	let updatePublisher: AnyPublisher<Void, Never>

	var newsSources: [String] = [
		"https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml",
		"https://www.vedomosti.ru/rss/news.xml",
		"https://www.cbsnews.com/latest/rss/main",
		"https://www.lenta.ru/rss/articles/russia"
	]
}
