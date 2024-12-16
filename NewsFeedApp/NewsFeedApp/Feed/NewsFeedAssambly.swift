//
//  NewsFeedAssambly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Foundation

final class NewsFeedAssambly {

	static func build() -> NewsFeedViewController {
		NewsFeedViewController(
			with: NewsFeedViewModel(
				dependencies: .init(
					apiService: APIService(rssParser: RSSParserService()),
					imageLoader: ImageLoader()
				)
			)
		)
	}
}
