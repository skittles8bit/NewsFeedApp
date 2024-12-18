//
//  SettingsViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

typealias SettingsViewModelProtocol =
SettingsViewModelInputOutput & SettingsViewModelActionsAndData

final class SettingsViewModel: SettingsViewModelProtocol {

	struct Dependencies {
		let dataStoreService: DataStoreServiceProtocol
	}

	let input: SettingsViewModelInput = .init()
	let output: SettingsViewModelOutput = .init()
	let data: SettingsViewModelData = .init()
	private(set) lazy var viewActions = SettingsViewModelActions()

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		bind()
	}
}

private extension SettingsViewModel {

	func bind() {
		viewActions.lifecycle.sink { [weak self] lifecycle in
			guard let self else { return }
			switch lifecycle {
			case .didLoad:
				break
			}
		}.store(in: &subscriptions)

		viewActions.events.sink { [weak self] event in
			guard let self else { return }
			switch event {
			case .clearCacheDidTap:
				clearCache()
			}
		}.store(in: &subscriptions)
	}

	func clearCache() {
		dependencies.dataStoreService.deleteAllNews()
		ImageLoader.shared.clearCache()
	}
}
