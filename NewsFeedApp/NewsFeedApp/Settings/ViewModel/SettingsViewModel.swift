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

	private var timeInterval: TimeIntervalModel?

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		bind()
	}
}

private extension SettingsViewModel {

	func bind() {
		viewActions.lifecycle.sink {lifecycle in
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
			case let .timerDidChange(model):
				timeInterval = model
				saveSettings()
			}
		}.store(in: &subscriptions)
	}

	func clearCache() {
		dependencies.dataStoreService.deleteAllNews()
		ImageLoader.shared.clearCache()
	}

	func saveSettings() {
		guard let timeInterval else { return }
		let settings = SettingsModel(timerModel: timeInterval)
		dependencies.dataStoreService.saveSettings(with: settings)
	}
}
