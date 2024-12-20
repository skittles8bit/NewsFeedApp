//
//  SettingsViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

/// Данные вью модели настроек
struct SettingsViewModelData {
	/// Обновления ячейки настроек
	let updateSettingsCellPublisher: AnyPublisher<(title: String, isEnabled: Bool), Never>
	/// Обновление состояния пикер вью
	let pickerViewStatePublisher: AnyPublisher<SettingsPickerViewStateModel, Never>
}
