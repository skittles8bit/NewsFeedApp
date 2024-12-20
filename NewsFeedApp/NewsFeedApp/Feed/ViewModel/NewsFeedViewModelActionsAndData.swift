//
//  NewsFeedViewModelActionsAndData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 13.12.24.
//

/// Протокол данных и экшенов вьюмодели
protocol NewsFeedViewModelActionsAndData {
	/// Данные вьюмодели
	var data: NewsFeedViewModelData { get }
	/// Экшены вью
	var viewActions: NewsFeedViewModelActions { get }
}
