//
//  NewsFeedCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import SafariServices
import UIKit

protocol NewsFeedCoordinatorProtocol {
	func start()
}

final class NewsFeedCoordinator: NewsFeedCoordinatorProtocol {

	struct Dependencies {
		let storage: StorageServiceProtocol
	}

	private lazy var settingsCoordinator: SettingsCoordinatorProtocol = {
		SettingsCoordinator(
			dependencies: .init(
				storage: dependencies.storage
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
		assembly.viewModel.output.performArticleDetailPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] url in
				guard let self else { return }
				showArticleDetail(with: url)
			}.store(in: &subscriptions)
	}

	func showSettings() {
		let coordinator = SettingsCoordinator(
			dependencies: .init(
				storage: dependencies.storage
			),
			navigationController: navigationController
		)
		coordinator.start()
	}

	func showArticleDetail(with url: URL) {
		let safariViewController = SFSafariViewController(url: url)
		safariViewController.dismissButtonStyle = .close
		safariViewController.configuration.entersReaderIfAvailable = true
		let vc = navigationController.viewControllers.first {
			$0 is NewsFeedViewController
		}
		vc?.present(safariViewController, animated: true)
	}
}
