//
//  SettingsViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

/// Протокол входных и выходных данных
protocol SettingsViewModelInputOutput {
	/// Входные данные
	var input: SettingsViewModelInput { get }
	/// Выходные данные
	var output: SettingsViewModelOutput { get }
}

/// Структура входных данных
struct SettingsViewModelInput {}

/// Структура выходных данных
struct SettingsViewModelOutput {
	/// Паблишер показа диалогового окна
	let showAlertPublisher: AnyPublisher<AlertModel, Never>
}
