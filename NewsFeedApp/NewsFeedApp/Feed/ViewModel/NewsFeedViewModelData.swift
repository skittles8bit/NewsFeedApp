//
//  NewsFeedViewModelData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

import Combine

/// Данные вьюмодели ленты новостей
struct NewsFeedViewModelData {
	/// Паблишер состояния загрузки данных
	let loadingPublisher: AnyPublisher<Void, Never>
	/// Паблишер обновления данных
	let reloadDataPublisher: AnyPublisher<Void, Never>
	/// Паблишер показа ошибки
	let errorPublisher: AnyPublisher<Void, Never>
	/// Паблишер применения изменений
	let applySnapshotPublisher: AnyPublisher<Void, Never>
	/// Массив новостей
	var newsFeedItems: [NewsFeedModelDTO]
}
