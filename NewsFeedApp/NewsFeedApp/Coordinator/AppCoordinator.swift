//
//  AppCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

protocol AppCoordinatorProtocol {
	func start()
}

final class AppCoordinator: AppCoordinatorProtocol {

	private lazy var newsFeedCoordinator: NewsFeedCoordinatorProtocol = {
		let assembly = NewsFeedAssembly(
			dependencies: .init(
				dataStoreService: DataStoreService()
			)
		)
		let coordinator = assembly.newsFeedCoordinator(
			dependencies: .init(dataStoreService: DataStoreService()),
			navigationController: navigationController
		)
		return coordinator
	}()

	private var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		newsFeedCoordinator.start()
	}
}
