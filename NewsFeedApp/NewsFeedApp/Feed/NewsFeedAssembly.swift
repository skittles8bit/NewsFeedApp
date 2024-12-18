//
//  NewsFeedAssembly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit
import RealmSwift

final class NewsFeedAssembly {

	let view: UIViewController
	let viewModel: NewsFeedViewModelInputOutput

	init(dependencies: NewsFeedCoordinator.Dependencies) {
		let model = NewsFeedViewModel(
			dependencies: NewsFeedViewModel.Dependencies(
				repository: NewsFeedRepository(
					storage: dependencies.dataStoreService,
					apiService: APIService(rssParser: RSSParserService())
				)
			)
		)
		viewModel = model
		let controller = NewsFeedViewController(with: model)
		view = controller
	}

	func newsFeedCoordinator(
		dependencies: NewsFeedCoordinator.Dependencies,
		navigationController: UINavigationController
	) -> NewsFeedCoordinator {
		NewsFeedCoordinator(
			dependencies: dependencies,
			navigationController: navigationController
		)
	}
}
