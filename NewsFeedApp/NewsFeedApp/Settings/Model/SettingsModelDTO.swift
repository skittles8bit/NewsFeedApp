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
	var timerEnabled: Bool { _timerEnabled }
	/// Интервал обновления
	var period: Int { _period }

	private let _period: Int
	private let _timerEnabled: Bool

	/// Инициализатор
	///  - Parameters:
	///   - period: Интервал обновления
	///   - timerEnabled: Доступно ли обновление по таймеру
	init(period: Int, timerEnabled: Bool) {
		_period = period
		_timerEnabled = timerEnabled
	}
}
