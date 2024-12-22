//
//  SettingsViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine
import Foundation

/// Элиас протоколов вью модели настроек
typealias SettingsViewModelProtocol =
SettingsViewModelInputOutput & SettingsViewModelActionsAndData

/// Вью модель настроек
final class SettingsViewModel: SettingsViewModelProtocol {

	/// Зависимости
	struct Dependencies {
		/// Репозиторий настроек
		let repository: SettingsRepositoryProtocol
	}

	/// Входные данные
	let input: SettingsViewModelInput = .init()
	/// Выходные данные
	let output: SettingsViewModelOutput
	/// Данные вью модели
	let data: SettingsViewModelData

	private(set) lazy var viewActions = SettingsViewModelActions()

	private let updateSettingsCellSubject = PassthroughSubject<[SettingsCellViewModel], Never>()
	private let pickerViewStateSubject = PassthroughSubject<SettingsPickerViewStateModel, Never>()
	private let alertShowSubject = PassthroughSubject<AlertModel, Never>()
	private let newsSourceButtonStateSubject = PassthroughSubject<Bool, Never>()
	private let showNewsSourceSubject = PassthroughSubject<Void, Never>()

	private var interval: Int = Constants.defaultPeriodValue
	private var timerIsEnabled: Bool = false
	private var showDescriptionIsEnabled: Bool = false
	private var newsSourceIsEnabled: Bool = false

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вью модели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		self.data = SettingsViewModelData(
			updateSettingsCellPublisher: updateSettingsCellSubject.eraseToAnyPublisher(),
			pickerViewStatePublisher: pickerViewStateSubject.eraseToAnyPublisher(),
			newsSourceButtonStatePublisher: newsSourceButtonStateSubject.eraseToAnyPublisher()
		)
		self.output = SettingsViewModelOutput(
			showAlertPublisher: alertShowSubject.eraseToAnyPublisher(),
			showNewsSourcePublisher: showNewsSourceSubject.eraseToAnyPublisher()
		)
		bind()
	}
}

// MARK: - Private

private extension SettingsViewModel {

	enum Constants {
		static let defaultPeriodValue: Int = 10
	}

	func bind() {
		viewActions.lifecycle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] lifecycle in
				guard let self else { return }
				switch lifecycle {
				case .didLoad,
						.didAppear:
					getUserSettings()
				case .willAppear:
					break
				case .willDisappear:
					break
				}
			}.store(in: &subscriptions)

		viewActions.events
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				guard let self else { return }
				switch event {
				case .clearCacheDidTap:
					clearCache()
					return
				case let .timerDidChange(time):
					interval = time
				case .settingsToggleDidChange(let type, let switchToogleState):
					handleToggleState(with: type, and: switchToogleState)
				case .newsSourceDidTap:
					showNewsSourceSubject.send()
				}
				saveUserSettings()
			}.store(in: &subscriptions)
	}

	func handleToggleState(
		with type: SettingsCellViewModel.SettingsCellType,
		and switchToogleState: Bool
	) {
		switch type {
		case .timer:
			timerIsEnabled = switchToogleState
			pickerViewStateSubject.send(
				.init(
					period: interval,
					isEnabled: timerIsEnabled
				)
			)
		case .description:
			showDescriptionIsEnabled = switchToogleState
		case .newsSource:
			newsSourceIsEnabled = switchToogleState
			newsSourceButtonStateSubject.send(switchToogleState)
		}
	}

	func clearCache() {
		let model = AlertModel(with: .conformation) { [weak self] actionState in
			guard let self else { return }
			switch actionState {
			case .clear:
				dependencies.repository.clearAllCache()
				let model = AlertModel(with: .done)
				alertShowSubject.send(model)
			default:
				break
			}
		}
		alertShowSubject.send(model)
	}

	func saveUserSettings() {
		interval = timerIsEnabled ? interval : Constants.defaultPeriodValue
		let settings = SettingsModelDTO(
			interval: interval,
			timerIsEnabled: timerIsEnabled,
			showDescriptionIsEnabled: showDescriptionIsEnabled,
			newsSourceIsEnabled: newsSourceIsEnabled
		)
		dependencies.repository.saveSettings(settings)
	}

	func getUserSettings() {
		let settings = dependencies.repository.fetchSettings()
		handleUserSettings(settings)
	}

	func handleUserSettings(_ settings: SettingsModelDTO?) {
		let updateCellModel: SettingsCellViewModel = .init(
			title: "Динамическое обновление ленты",
			subtitle: "При включенном тоггле обновление ленты происходит с интервалом, указанным в поле ввода",
			isOn: settings?.timerIsEnabled ?? false,
			type: .timer
		)
		let showDescriptionCellModel: SettingsCellViewModel = .init(
			title: "Краткое описание новости",
			subtitle: "Новость будет отображаться с кратким описанием",
			isOn: settings?.showDescriptionIsEnabled ?? false,
			type: .description
		)
		let newsSource: SettingsCellViewModel = .init(
			title: "Источник новостей",
			subtitle: "Обновление ленты новостей будет происходит по указанному источнику новостей",
			isOn: settings?.newsSourceIsEnabled ?? false,
			type: .newsSource
		)
		updateSettingsCellSubject.send([updateCellModel, showDescriptionCellModel, newsSource])
		newsSourceButtonStateSubject.send(settings?.newsSourceIsEnabled ?? false)
		pickerViewStateSubject.send(
			.init(
				period: settings?.interval ?? Constants.defaultPeriodValue,
				isEnabled: settings?.timerIsEnabled ?? false
			)
		)
	}
}
