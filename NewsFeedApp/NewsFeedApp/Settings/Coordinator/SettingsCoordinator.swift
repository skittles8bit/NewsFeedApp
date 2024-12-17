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

	private let assembly: SettingsAssembly
	private let navigationController: UINavigationController

	private var subscriptions = Subscriptions()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.assembly = SettingsAssembly()
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}
