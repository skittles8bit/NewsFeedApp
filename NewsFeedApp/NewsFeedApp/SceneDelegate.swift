//
//  SceneDelegate.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: scene)
		window?.rootViewController = NewsFeedViewController(
			viewModel: NewsFeedViewModel(
				dependencies: .init()
			)
		)
		window?.makeKeyAndVisible()
	}
}

