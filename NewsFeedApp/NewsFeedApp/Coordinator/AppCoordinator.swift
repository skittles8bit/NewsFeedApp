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

	private var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		print("Assembly NewsFeedViewController")
		let vc = NewsFeedAssambly.build()
		print("Push NewsFeedViewController")
		navigationController.pushViewController(vc, animated: true)
	}
}
