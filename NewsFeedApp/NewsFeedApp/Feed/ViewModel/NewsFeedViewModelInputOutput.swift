//
//  NewsFeedViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine
import Foundation

protocol NewsFeedViewModelInputOutput {
	var input: NewsFeedViewModelInput { get }
	var output: NewsFeedViewModelOutput { get }
}

struct NewsFeedViewModelInput {}

struct NewsFeedViewModelOutput {
	/// Переход в настройки
	let performSettingsPublisher: AnyPublisher<Void, Never>
	/// Переход на детальную информацию о статье
	let performArticleDetailPublisher: AnyPublisher<URL, Never>
}
