//
//  NewSourceViewModelActionsAndData.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Foundation

/// Протокол данных и экшенов вьюмодели
protocol NewsSourceViewModelActionsAndData {
	/// Данные вьюмодели
	var data: NewsSourceViewModelData { get }
	/// Экшены вью
	var viewActions: NewsSourceViewModelActions { get }
}
