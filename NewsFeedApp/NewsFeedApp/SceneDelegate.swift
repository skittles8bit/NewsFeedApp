//
//  SceneDelegate.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var appCoordinator: AppCoordinatorProtocol?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: scene)
		let navigationController = UINavigationController()
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		appCoordinator = AppCoordinator(navigationController: navigationController)
		appCoordinator?.start()
	}
}
