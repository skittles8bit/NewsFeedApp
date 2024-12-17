//
//  NewsFeedCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

protocol NewsFeedCoordinatorProtocol {
	func start()
}

final class NewsFeedCoordinator: NewsFeedCoordinatorProtocol {

	private lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
		SettingsCoordinator(navigationController: navigationController)
	}()

	private let assembly: NewsFeedAssembly
	private let navigationController: UINavigationController

	private var subscriptions = Subscriptions()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.assembly = NewsFeedAssembly()
		bind()
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}

private extension NewsFeedCoordinator {

	func bind() {
		assembly.viewModel.output.performSettingsPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				showSettings()
			}.store(in: &subscriptions)
	}

	func showSettings() {
		settingsCoordinator.start()
	}
}
