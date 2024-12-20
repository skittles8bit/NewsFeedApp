//
//  SettingsModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 18.12.24.
//

import Foundation

/// Модель данных настроек
struct SettingsModelDTO {

	/// Доступно ли обновление по таймеру
	var timerIsEnabled: Bool { _timerIsEnabled }
	/// Интервал обновления
	var interval: Int { _interval }
	var showDescriptionIsEnabled: Bool { _showDescriptionIsEnabled }

	private let _interval: Int
	private let _timerIsEnabled: Bool
	private let _showDescriptionIsEnabled: Bool

	/// Инициализатор
	///  - Parameters:
	///   - interval: Интервал обновления
	///   - timerIsEnabled: Доступно ли обновление по таймеру
	init(interval: Int, timerIsEnabled: Bool, showDescriptionIsEnabled: Bool) {
		_interval = interval
		_timerIsEnabled = timerIsEnabled
		_showDescriptionIsEnabled = showDescriptionIsEnabled
	}
}
