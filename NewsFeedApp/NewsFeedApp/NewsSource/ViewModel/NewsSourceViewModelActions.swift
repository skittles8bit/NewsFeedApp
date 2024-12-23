//
//  NewsSourceViewModelActions.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Combine

// Экшены вью
struct NewsSourceViewModelActions {

	/// Энам событий вью
	enum Events {
		/// Нажата кнопка сохранить или обновить
		case didTapSaveOrUpdateButton(Int, String)
		/// Нажата кнопка добавить новый источник
		case didTapAddButton(String)
		/// Удалить источник
		case didTapDelete(Int)
	}

	/// Методы жизненного цикла вью контроллера
	let lifecycle = PassthroughSubject<Lifecycle, Never>()
	/// События вью
	let events = PassthroughSubject<Events, Never>()
}
