//
//  NewSourceAssembly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

final class NewsSourceAsssembly {

	let view: UIViewController
	let viewModel: NewsSourceViewModelInputOutput

	init(dependencies: NewsSourceCoordinator.Dependencies) {
		let model = NewsSourceViewModel(dependencies: .init(storage: dependencies.storage))
		viewModel = model
		let controller = NewsSourceViewController(viewModel: model)
		view = controller
	}

	func makeNewsSourceCoordinator(
		dependencies: NewsSourceCoordinator.Dependencies,
		and navigationController: UINavigationController
	) -> NewsSourceCoordinator {
		.init(
			dependencies: dependencies,
			navigationController: navigationController
		)
	}
}
