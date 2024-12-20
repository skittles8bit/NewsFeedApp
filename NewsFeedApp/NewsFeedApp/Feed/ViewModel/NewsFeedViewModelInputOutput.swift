//
//  NewsFeedViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine
import Foundation

/// Протокол входных и выходных данных
protocol NewsFeedViewModelInputOutput {
	/// Входные данные
	var input: NewsFeedViewModelInput { get }
	/// Выходные данные
	var output: NewsFeedViewModelOutput { get }
}

/// Структура входных данных
struct NewsFeedViewModelInput {}

/// Структура выходных данных
struct NewsFeedViewModelOutput {
	/// Переход в настройки
	let performSettingsPublisher: AnyPublisher<Void, Never>
	/// Переход на детальную информацию о статье
	let performArticleDetailPublisher: AnyPublisher<URL, Never>
}
