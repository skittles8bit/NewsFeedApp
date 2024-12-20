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

	private let updateSettingsCellSubject = PassthroughSubject<(title: String, isEnabled: Bool), Never>()
	private let pickerViewStateSubject = PassthroughSubject<SettingsPickerViewStateModel, Never>()
	private let alertShowSubject = PassthroughSubject<AlertModel, Never>()

	private var period: Int = Constants.defaultPeriodValue
	private var timerEnabled: Bool = false

	private let dependencies: Dependencies

	private var subscriptions = Subscriptions()

	/// Инициализатор
	///  - Parameters:
	///   - dependencies: Зависимости вью модели
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		self.data = SettingsViewModelData(
			updateSettingsCellPublisher: updateSettingsCellSubject.eraseToAnyPublisher(),
			pickerViewStatePublisher: pickerViewStateSubject.eraseToAnyPublisher()
		)
		self.output = SettingsViewModelOutput(
			showAlertPublisher: alertShowSubject.eraseToAnyPublisher()
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
				if case .didLoad = lifecycle {
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
				case let .timerDidChange(time):
					period = time
				case let .timerStateDidChange(value):
					timerEnabled = value
					pickerViewStateSubject.send(
						.init(
							period: period,
							isEnabled: timerEnabled
						)
					)
				}
				saveSettings()
			}.store(in: &subscriptions)
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

	func saveSettings() {
		period = timerEnabled ? period : Constants.defaultPeriodValue
		let settings = SettingsModelDTO(period: period, timerEnabled: timerEnabled)
		dependencies.repository.saveSettings(settings)
	}

	func getSettings() {
		let settings = dependencies.repository.fetchSettings()
		timerEnabled = settings?.timerEnabled ?? false
		period = settings?.period ?? Constants.defaultPeriodValue
		let model: (String, Bool) = ("Активировать обновление новостей \nпо таймеру", timerEnabled)
		updateSettingsCellSubject.send(model)
		pickerViewStateSubject.send(
			.init(
				period: period,
				isEnabled: timerEnabled
			)
		)
	}
}
