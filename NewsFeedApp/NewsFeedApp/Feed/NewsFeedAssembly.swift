//
//  NewsFeedAssembly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import RealmSwift
import UIKit

/// Сборщик ленты новостей
final class NewsFeedAssembly {

	/// Вью контроллер
	let view: UIViewController
	/// Вью модель
	let viewModel: NewsFeedViewModelInputOutput

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости координатора
	init(dependencies: NewsFeedCoordinator.Dependencies) {
		let model = NewsFeedViewModel(
			dependencies: NewsFeedViewModel.Dependencies(
				newsRepository: NewsFeedRepository(
					storage: dependencies.storage,
					apiService: APIService(rssParser: RSSParserService())
				),
				settingsRepository: SettingsRepository(storage: dependencies.storage)
			)
		)
		viewModel = model
		let controller = NewsFeedViewController(with: model)
		view = controller
	}

	func makeNewsFeedCoordinator(
		dependencies: NewsFeedCoordinator.Dependencies,
		navigationController: UINavigationController
	) -> NewsFeedCoordinator {
		NewsFeedCoordinator(
			dependencies: dependencies,
			navigationController: navigationController
		)
	}
}
