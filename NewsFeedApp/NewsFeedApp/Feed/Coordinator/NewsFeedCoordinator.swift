//
//  NewsFeedCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import SafariServices
import SwiftUI
import UIKit

/// Протокол запуска координатора ленты новостей
protocol NewsFeedCoordinatorProtocol {
	/// Метод старта координатора
	func start()
}

/// Координатор ленты новостей
final class NewsFeedCoordinator: NewsFeedCoordinatorProtocol {

	/// Зависимости координатора
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

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависиммости координатора
	///   - navigationController: Презентер
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

// MARK: - Private

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
		let settingsViewModel = SettingsViewViewModel(storageService: dependencies.storage)
		let hostingViewController = UIHostingController(rootView: SettingsView(viewModel: settingsViewModel))
		navigationController.pushViewController(hostingViewController, animated: true)
//		settingsCoordinator.start()
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
