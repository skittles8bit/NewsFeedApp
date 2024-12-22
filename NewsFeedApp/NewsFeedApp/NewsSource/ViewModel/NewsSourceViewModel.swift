//
//  NewsSourceViewModel.swift
//  NewsFeedApp
//
//  Created by Aliaksandr Karenski on 23.12.24.
//

import Foundation

typealias NewsSourceViewModelProtocol =
NewsSourceViewModelInputOutput & NewsSourceViewModelActionsAndData

final class NewsSourceViewModel: NewsSourceViewModelProtocol {

	/// Зависимости
	struct Dependencies {
		/// Сервис хранения данных
		let storage: StorageServiceProtocol
	}

	/// Входные данные
	let input: NewsSourceViewModelInput = .init()
	/// Выходные данные
	let output: NewsSourceViewModelOutput = .init()
	/// Данные вью модели
	let data: NewsSourceViewModelData = .init()

	private(set) lazy var viewActions = NewsSourceViewModelActions()

	private let dependencies: Dependencies

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
}
