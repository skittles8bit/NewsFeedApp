//
//  SettingsViewModelActions.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 17.12.24.
//

import Combine

/// Экшены вью
struct SettingsViewModelActions {

	/// Энам событий вью
	enum Events {
		/// Нажата кнопка очистки кэша
		case clearCacheDidTap
		/// Значение таймера изменено
		case timerDidChange(Int)
		/// Значение тоггла изменено
		case timerStateDidChange(Bool)
	}

	/// Методы жизненного цикла вью контроллера
	let lifecycle = PassthroughSubject<Lifecycle, Never>()
	/// События вью
	let events = PassthroughSubject<Events, Never>()
}
