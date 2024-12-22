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
	/// Показывать ли описание новости
	var showDescriptionIsEnabled: Bool { _showDescriptionIsEnabled }
	/// Активировать ли источник новостей
	var newsSourceIsEnabled: Bool { _newsSourceIsEnabled }

	private let _interval: Int
	private let _timerIsEnabled: Bool
	private let _showDescriptionIsEnabled: Bool
	private let _newsSourceIsEnabled: Bool

	/// Инициализатор
	///  - Parameters:
	///   - interval: Интервал обновления
	///   - timerIsEnabled: Доступно ли обновление по таймеру
	///   - showDescriptionIsEnabled: Показывать ли описание новости
	///   - newsSourceIsEnabled: Активировать ли источник новостей
	init(
		interval: Int,
		timerIsEnabled: Bool,
		showDescriptionIsEnabled: Bool,
		newsSourceIsEnabled: Bool
	) {
		_interval = interval
		_timerIsEnabled = timerIsEnabled
		_showDescriptionIsEnabled = showDescriptionIsEnabled
		_newsSourceIsEnabled = newsSourceIsEnabled
	}
}
