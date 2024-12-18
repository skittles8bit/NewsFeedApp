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
		bind()
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}

private extension SettingsCoordinator {

	func bind() {
		assembly.viewModel.output.backButtonPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				self?.navigationController.popToRootViewController(animated: true)
			}.store(in: &subscriptions)
	}
}
