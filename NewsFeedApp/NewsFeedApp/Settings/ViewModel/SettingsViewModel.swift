//
//  SettingsViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine
import Foundation

typealias SettingsViewModelProtocol =
SettingsViewModelInputOutput & SettingsViewModelActionsAndData

final class SettingsViewModel: SettingsViewModelProtocol {

	struct Dependencies {
		let dataStoreService: DataStoreServiceProtocol
	}

	let input: SettingsViewModelInput = .init()
	let output: SettingsViewModelOutput = .init()
	let data: SettingsViewModelData
	private(set) lazy var viewActions = SettingsViewModelActions()

	private let switchStateSubject = PassthroughSubject<Bool, Never>()
	private let pickerViewStateSubject = PassthroughSubject<Bool, Never>()

	private var timeInterval: TimeIntervalModel?
	private var timerEnabled: Bool = false

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		self.data = SettingsViewModelData(
			switchStatePublisher: switchStateSubject.eraseToAnyPublisher(),
			pickerViewStatePublisher: pickerViewStateSubject.eraseToAnyPublisher()
		)
		bind()
	}
}

private extension SettingsViewModel {

	func bind() {
		viewActions.lifecycle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] lifecycle in
				guard let self else { return }
				switch lifecycle {
				case .didLoad:
					getSettings()
				}
			}.store(in: &subscriptions)

		viewActions.events
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case .clearCacheDidTap:
					clearCache()
				case let .timerDidChange(model):
					timeInterval = model
					saveSettings()
				case let .timerStateDidChange(value):
					timerEnabled = value
					pickerViewStateSubject.send(value)
				}
			}.store(in: &subscriptions)
	}

	func clearCache() {
		dependencies.dataStoreService.claerCache()
	}

	func saveSettings() {
		guard let timeInterval else { return }
		let settings = SettingsModel(timerModel: timeInterval, timerEnabled: timerEnabled)
		dependencies.dataStoreService.saveSettings(with: settings)
	}

	func getSettings() {
		let settings = dependencies.dataStoreService.getSettings()
		timerEnabled = settings?.timerEnabled ?? false
		switchStateSubject.send(timerEnabled)
		pickerViewStateSubject.send(timerEnabled)
	}
}
