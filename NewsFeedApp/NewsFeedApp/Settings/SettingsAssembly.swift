//
//  SettingsAssembly.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import UIKit

final class SettingsAssembly {

	let view: UIViewController
	let viewModel: SettingsViewModelInputOutput

	init(dependencies: SettingsCoordinator.Dependencies) {
		let model = SettingsViewModel(
			dependencies: .init(
				dataStoreService: dependencies.storage
			)
		)
		viewModel = model
		let controller = SettingsViewController(viewModel: model)
		view = controller
	}
}
