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

	struct Dependencies {
		let dataStoreService: DataStoreServiceProtocol
	}

	private lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
		SettingsCoordinator(
			dependencies: .init(
				dataStoreService: dependencies.dataStoreService
			),
			navigationController: navigationController
		)
	}()

	private let assembly: NewsFeedAssembly
	private let navigationController: UINavigationController
	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	init(
		dependencies: Dependencies,
		navigationController: UINavigationController
	) {
		self.dependencies = dependencies
		self.navigationController = navigationController
		self.assembly = NewsFeedAssembly(dependencies: dependencies)
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
