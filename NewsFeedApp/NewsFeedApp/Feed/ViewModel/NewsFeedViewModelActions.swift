//
//  NewsFeedViewModelActions.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine

/// Экшены вью
struct NewsFeedViewModelActions {

	/// Энам событий вью
	enum Events {
		/// Нужно обновить данные
		case didUpdate
		/// Нажата кнопка настроек
		case didTapSettings
		/// Нажата ячейка
		case didTapArticle(Int)
	}

	/// Методы жизненного цикла вью контроллера
	let lifecycle = PassthroughSubject<Lifecycle, Never>()
	/// События вью
	let events = PassthroughSubject<Events, Never>()
}
