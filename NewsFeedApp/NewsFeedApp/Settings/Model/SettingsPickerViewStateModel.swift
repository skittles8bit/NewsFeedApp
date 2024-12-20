//
//  SettingsPickerViewStateModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 19.12.24.
//

import Foundation

/// Модель для пикер вью
struct SettingsPickerViewStateModel {
	/// Интервал обновления
	let period: Int
	/// Доступен ли
	let isEnabled: Bool
}
