//
//  NewsFeedAssambly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

final class NewsFeedAssambly {

	let view: UIViewController
	let viewModel: NewsFeedViewModelInputOutput

	init() {
		let model = NewsFeedViewModel(
			dependencies: NewsFeedViewModel.Dependencies(
				apiService: APIService(rssParser: RSSParserService())
			)
		)
		viewModel = model
		let controller = NewsFeedViewController(with: model)
		view = controller
	}

	func newsFeedCoordinator(
		navigationController: UINavigationController
	) -> NewsFeedCoordinator {
		NewsFeedCoordinator(navigationController: navigationController)
	}
}
