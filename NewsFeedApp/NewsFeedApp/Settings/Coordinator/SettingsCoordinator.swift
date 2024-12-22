//
//  SettingsCoordinator.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

/// Протокол координатора настроек
protocol SettingsCoordinatorProtocol {
	/// Старт координатора
	func start()
}

/// Координатор настроек
final class SettingsCoordinator: SettingsCoordinatorProtocol {

	/// Зависимости
	struct Dependencies {
		/// Сервис хранения данных
		let storage: StorageServiceProtocol
	}

	private lazy var newsSourceCoordinator: NewsSourceCoordinatorProtocol = {
		let storage = dependencies.storage
		let dependencies = NewsSourceCoordinator.Dependencies(storage: storage)
		let assembly = NewsSourceAsssembly(dependencies: dependencies)
		let coordinator = assembly.makeNewsSourceCoordinator(
			dependencies: dependencies,
			and: navigationController
		)
		return coordinator
	}()

	private let assembly: SettingsAssembly
	private let navigationController: UINavigationController
	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости координатора
	///   - navigationController: Презентер
	init(
		dependencies: Dependencies,
		navigationController: UINavigationController
	) {
		self.dependencies = dependencies
		self.navigationController = navigationController
		self.assembly = SettingsAssembly(dependencies: dependencies)
		bind()
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}

// MARK: - Private

private extension SettingsCoordinator {

	func bind() {
		assembly.viewModel.output.showAlertPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				guard let self else { return }
				showAlert(with: model)
			}.store(in: &subscriptions)
		assembly.viewModel.output.showNewsSourcePublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in
				guard let self else { return }
				showNewsSource()
			}.store(in: &subscriptions)
	}

	func showAlert(with model: AlertModel) {
		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)
		model.actions.forEach { alert.addAction($0) }
		navigationController.present(alert, animated: true)
	}

	func showNewsSource() {
		newsSourceCoordinator.start()
	}
}
