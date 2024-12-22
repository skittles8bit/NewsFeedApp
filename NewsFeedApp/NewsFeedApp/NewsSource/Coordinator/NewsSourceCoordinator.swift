//
//  NewsSourceCoordinator.swift
//  Pods
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import UIKit

protocol NewsSourceCoordinatorProtocol {
	/// Старт координатора
	func start()
}

final class NewsSourceCoordinator: NewsSourceCoordinatorProtocol {

	/// Зависимости
	struct Dependencies {
		/// Сервис хранения данных
		let storage: StorageServiceProtocol
	}

	private let assembly: NewsSourceAsssembly
	private let navigationController: UINavigationController

	private var subscriptions = Subscriptions()

	// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости координатора
	///   - navigationController: Презентер
	init(
		dependencies: Dependencies,
		navigationController: UINavigationController
	) {
		self.navigationController = navigationController
		self.assembly = NewsSourceAsssembly(dependencies: dependencies)
	}

	func start() {
		navigationController.pushViewController(assembly.view, animated: true)
	}
}
