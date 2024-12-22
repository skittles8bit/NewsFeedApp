//
//  AppCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

/// Протокол запуска координатора приложения
protocol AppCoordinatorProtocol {
	/// Старт координатора
	func start()
}

/// Координатор приложения
final class AppCoordinator: AppCoordinatorProtocol {

	/// Координатор ленты новостей
	private lazy var newsFeedCoordinator: NewsFeedCoordinatorProtocol = {
		let storageService = StorageService()
		let assembly = NewsFeedAssembly(
			dependencies: .init(
				storage: storageService
			)
		)
		let coordinator = assembly.makeNewsFeedCoordinator(
			dependencies: .init(storage: storageService),
			navigationController: navigationController
		)
		return coordinator
	}()

	private var navigationController: UINavigationController

	/// Инициализатор
	///  - Parameters:
	///   - navigationController: Презентер
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		newsFeedCoordinator.start()
	}
}
