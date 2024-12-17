//
//  NewsFeedViewModelInputOutput.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

protocol NewsFeedViewModelInputOutput {
	var input: NewsFeedViewModelInput { get }
	var output: NewsFeedViewModelOutput { get }
}

struct NewsFeedViewModelInput {}

struct NewsFeedViewModelOutput {
	/// Переход в настройки
	let performSettingsPublisher: AnyPublisher<Void, Never>
}
