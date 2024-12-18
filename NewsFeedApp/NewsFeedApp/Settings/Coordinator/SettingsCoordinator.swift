//
//  SettingsCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

protocol SettingsCoordinatorProtocol {
	func start()
}

final class SettingsCoordinator: SettingsCoordinatorProtocol {

	struct Dependencies {
		let storage: StorageServiceProtocol
	}

	private let assembly: SettingsAssembly
	private let navigationController: UINavigationController

	private var subscriptions = Subscriptions()

	init(
		dependencies: Dependencies,
		navigationController: UINavigationController
	) {
		self.navigationController = navigationController
		self.assembly = SettingsAssembly(dependencies: dependencies)
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}
